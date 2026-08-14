"""ProviderRouter — one `ProviderClient` that dispatches by the `provider:` prefix of a model
string to a per-provider client, built lazily from its SecretStore profile and cached.

This is the single provider the `SessionManager` hands to every engine, so `complete()/stream()`
(which already receive the full model string per-call) route themselves: `ollama:llama3.3` →
the Ollama client (Ollama's OpenAI-compatible `/v1`), bare `gpt-5.5` → the default (OpenAI). The
prefix is stripped before delegating, since the underlying SDKs want the bare model name.

**Fallback chains.** A model string may be a comma-separated ordered chain —
`gemini:gemini-3.6-flash,groq:llama-3.3-70b-versatile,mistral:mistral-large-latest` — tried
left to right. The first candidate that answers wins ("stable first, others in order"); a
candidate is skipped when it fails before producing anything (quota 402, rate-limit 429, 5xx,
bad key, timeout, …). For streaming, fallback only happens before the first chunk; a failure
mid-stream is surfaced to the caller because partial output can't be rolled back.

Config changes (a new key, a new Ollama URL) call `invalidate()` to drop cached clients, so
existing engines pick up the change without a rebuild.
"""

from __future__ import annotations

import json
import threading
from typing import Any, Optional

from .base import ProviderClient
from .capabilities import capabilities_for
from .registry import build_provider_client, get_descriptor

# Rough per-provider prompt-size ceilings (estimated input tokens). Providers with a small
# free tier — Groq's on_demand TPM was 8000 on this account (2026-08-14) — hard-fail a large
# request with a 413 BEFORE producing anything; skipping them up front keeps the chain fast
# and quiet (the user's big session was 18.6k tokens). Estimate = chars/4 (standard heuristic;
# these are ceilings, not billing). None = no guard.
_PROMPT_SIZE_GUARD: dict[str, Optional[int]] = {"groq": 7000}


def _estimate_input_tokens(
    messages: list[dict[str, Any]], tools: Optional[list[dict[str, Any]]]
) -> int:
    chars = sum(
        len(json.dumps(m, default=str)) if isinstance(m, dict) else len(str(m))
        for m in messages
    )
    if tools:
        chars += len(json.dumps(tools, default=str))
    return max(chars // 4, 0)


class ProviderRouter(ProviderClient):
    def __init__(
        self,
        secrets: Any = None,
        *,
        default_provider: str = "openai",
        on_use: Any = None,
    ) -> None:
        self._secrets = secrets
        self._default = default_provider
        self._clients: dict[str, ProviderClient] = {}
        self._lock = threading.Lock()
        # Optional callable(provider_name) fired when a completion is dispatched — drives the
        # Settings pane's "Last used" line. Best-effort: its failures never break a model call.
        self._on_use = on_use

    def _note_use(self, model: str) -> None:
        if self._on_use is None:
            return
        try:
            self._on_use(self._provider_name(model))
        except Exception:
            pass

    def _too_large(
        self, candidate: str, messages: list[dict[str, Any]], tools: Any
    ) -> bool:
        """Skip a candidate up front when its provider's free tier can't fit the prompt."""
        limit = _PROMPT_SIZE_GUARD.get(self._provider_name(candidate))
        if not limit:
            return False
        return _estimate_input_tokens(messages, tools) > limit

    # -- routing ----------------------------------------------------------------
    def _provider_name(self, model: str) -> str:
        """The provider for a model: the `prefix` of `prefix:rest` if it's a known provider,
        else the default. (A colon that isn't a known provider — unlikely — falls through.)
        """
        if ":" in model:
            prefix = model.split(":", 1)[0]
            if get_descriptor(prefix) is not None:
                return prefix
        return self._default

    def _client_for(self, model: str) -> ProviderClient:
        name = self._provider_name(model)
        with self._lock:
            client = self._clients.get(name)
            if client is None:
                profile = {}
                if self._secrets is not None:
                    profile = self._secrets.get(f"provider:{name}") or {}
                client = build_provider_client(name, profile, self._secrets)
                self._clients[name] = client
            return client

    @staticmethod
    def _bare(model: str) -> str:
        """Strip a KNOWN provider prefix; the underlying SDK wants the bare model name. A model
        whose first segment isn't a provider (e.g. `qwen2.5-coder:32b` — a version tag, not a
        prefix) is returned unchanged, so the colon isn't mistaken for a provider separator.
        """
        if ":" in model:
            prefix, rest = model.split(":", 1)
            if get_descriptor(prefix) is not None:
                return rest
        return model

    @staticmethod
    def _chain(model: str) -> list[str]:
        """The ordered fallback chain from a model string: comma-separated candidates
        (`a,b,c`) tried left to right, or the single model when no comma is present.
        """
        parts = [p.strip() for p in (model or "").split(",") if p.strip()]
        return parts or [model]

    def invalidate(self, name: Optional[str] = None) -> None:
        """Drop cached client(s) so the next call rebuilds with fresh config."""
        with self._lock:
            if name is None:
                self._clients.clear()
            else:
                self._clients.pop(name, None)

    # -- ProviderClient ---------------------------------------------------------
    def complete(
        self,
        *,
        model: str,
        messages: list[dict[str, Any]],
        tools: Optional[list[dict[str, Any]]] = None,
        **settings: Any,
    ):
        last_err: Optional[Exception] = None
        for candidate in self._chain(model):
            if self._too_large(candidate, messages, tools):
                last_err = last_err or RuntimeError(
                    f"{candidate!r}: prompt too large for its free tier"
                )
                continue
            try:
                self._note_use(candidate)
                return self._client_for(candidate).complete(
                    model=self._bare(candidate), messages=messages, tools=tools, **settings
                )
            except Exception as exc:  # quota/rate/5xx/key/timeout → try the next candidate
                last_err = exc
                continue
        if last_err is not None:
            raise last_err
        raise RuntimeError(f"no providers attempted for model chain: {model!r}")

    def stream(
        self,
        *,
        model: str,
        messages: list[dict[str, Any]],
        tools: Optional[list[dict[str, Any]]] = None,
        **settings: Any,
    ):
        """Yield StreamChunks with "first chunk wins" fallback across the chain: a candidate
        is skipped only if it fails before producing its first chunk; once a stream starts it
        is kept to the end (mid-stream errors can't be rolled back and propagate to the caller).
        """
        last_err: Optional[Exception] = None
        for candidate in self._chain(model):
            if self._too_large(candidate, messages, tools):
                last_err = last_err or RuntimeError(
                    f"{candidate!r}: prompt too large for its free tier"
                )
                continue
            try:
                gen = self._client_for(candidate).stream(
                    model=self._bare(candidate), messages=messages, tools=tools, **settings
                )
                first = next(gen)  # may raise before any output → try the next candidate
            except StopIteration:  # candidate streamed nothing at all
                last_err = last_err or RuntimeError(f"{candidate!r}: empty stream")
                continue
            except Exception as exc:
                last_err = exc
                continue
            # First chunk secured — commit to this candidate. Everything after this point
            # sits OUTSIDE the try so a mid-stream error propagates to the caller (partial
            # output can't be rolled back), and `yield from` isn't mis-caught as a fallback.
            self._note_use(candidate)
            yield first
            yield from gen
            return
        if last_err is not None:
            raise last_err
        raise RuntimeError(f"no providers attempted for model chain: {model!r}")

    def capabilities(self, model: str):
        return capabilities_for(self._chain(model)[0])
