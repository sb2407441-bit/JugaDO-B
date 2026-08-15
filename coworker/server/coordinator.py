"""Two-coworker coordination broker.

Hermes (external WhatsApp/edge agent) and Human AI (governed executor) exchange
typed messages through this broker. It lives inside the Human AI sidecar so the
existing token auth, persistence base, and app-wide event stream are reused; the
Hermes laptop reads/writes it over the same authenticated bridge.

Protocol
--------
Every coordination item is a *thread* (topic slug) holding an ordered list of
*envelopes*. An envelope is one of:

    propose  -> critique -> critique -> decision -> execute -> report

Each envelope carries `from`/`to` peer ids, an optional `scope` describing which
laptop owns the operation, and a JSON `body`. Threads are immutable once their
final envelope is `report` or `aborted`.

State machine
-------------
    propose                    (open)
      └─ critique (0..n)      (open)
      └─ decision              (decided)
           └─ execute          (executing)
                └─ report      (done)
    aborted                    (closed, no further envelopes)

Peers poll `outbox?for=<peer>` and ack messages once handled, so delivery is
at-least-once with explicit ack (no webhook/websocket required on the edge).

Live UI: every mutation broadcasts an app-wide event `coordination_updated`
over the existing /ws/events stream so both laptops' dashboards update in real
time without polling.
"""
from __future__ import annotations

import json
import time
import uuid
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any, Awaitable, Callable, Optional

VALID_ENVELOPES = ("propose", "critique", "decision", "execute", "report", "aborted")
VALID_PEERS = ("hermes", "human-ai")
TERMINAL = ("report", "aborted")

Broadcaster = Callable[[dict[str, Any]], Awaitable[None]]


@dataclass
class Envelope:
    env_id: str
    kind: str
    sender: str
    recipient: str
    body: dict[str, Any]
    scope: str = ""
    created_at: float = field(default_factory=time.time)

    def to_dict(self) -> dict[str, Any]:
        return {
            "env_id": self.env_id,
            "kind": self.kind,
            "sender": self.sender,
            "recipient": self.recipient,
            "body": self.body,
            "scope": self.scope,
            "created_at": self.created_at,
        }


@dataclass
class Thread:
    thread_id: str
    title: str
    envelopes: list[Envelope] = field(default_factory=list)
    created_at: float = field(default_factory=time.time)
    updated_at: float = field(default_factory=time.time)

    @property
    def state(self) -> str:
        if not self.envelopes:
            return "open"
        last = self.envelopes[-1].kind
        return last if last in TERMINAL else "open" if last != "decision" else "decided"

    @property
    def decided(self) -> bool:
        return self.state in {"decided", "executing", "done"}

    def to_dict(self) -> dict[str, Any]:
        return {
            "thread_id": self.thread_id,
            "title": self.title,
            "state": self.state,
            "created_at": self.created_at,
            "updated_at": self.updated_at,
            "envelopes": [env.to_dict() for env in self.envelopes],
        }


class Coordinator:
    """Thread + envelope store persisted as one JSON file under the sidecar base."""

    def __init__(self, base: Path, broadcaster: Optional[Broadcaster] = None) -> None:
        self._path = Path(base) / "coordination.json"
        self._threads: dict[str, Thread] = {}
        self._outbox: dict[str, list[str]] = {peer: [] for peer in VALID_PEERS}
        self._acked: set[str] = set()
        self._broadcast: Optional[Broadcaster] = broadcaster
        self._load()

    # -- persistence ---------------------------------------------------------
    def _load(self) -> None:
        if not self._path.exists():
            return
        try:
            raw = json.loads(self._path.read_text(encoding="utf-8"))
        except (OSError, json.JSONDecodeError):
            return
        for t in raw.get("threads", []):
            thread = Thread(thread_id=t["thread_id"], title=t.get("title", ""))
            thread.created_at = t.get("created_at", thread.created_at)
            thread.updated_at = t.get("updated_at", thread.updated_at)
            for e in t.get("envelopes", []):
                thread.envelopes.append(
                    Envelope(
                        env_id=e["env_id"],
                        kind=e["kind"],
                        sender=e.get("sender", ""),
                        recipient=e.get("recipient", ""),
                        body=e.get("body", {}),
                        scope=e.get("scope", ""),
                        created_at=e.get("created_at", 0.0),
                    )
                )
            self._threads[thread.thread_id] = thread
        self._outbox = {
            peer: raw.get("outbox", {}).get(peer, []) for peer in VALID_PEERS
        }
        self._acked = set(raw.get("acked", []))

    def _persist(self) -> None:
        payload = {
            "threads": [t.to_dict() for t in self._threads.values()],
            "outbox": self._outbox,
            "acked": sorted(self._acked),
        }
        self._path.write_text(
            json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8"
        )

    async def _notify(self) -> None:
        if self._broadcast is not None:
            await self._broadcast(
                {"type": "coordination_updated", "data": {"threads": self.threads()}}
            )

    # -- queries -------------------------------------------------------------
    def threads(self, limit: int = 100) -> list[dict[str, Any]]:
        ordered = sorted(
            self._threads.values(), key=lambda t: t.updated_at, reverse=True
        )
        return [t.to_dict() for t in ordered[:limit]]

    def thread(self, thread_id: str) -> Optional[dict[str, Any]]:
        t = self._threads.get(thread_id)
        return t.to_dict() if t else None

    def outbox(self, peer: str) -> list[dict[str, Any]]:
        peer = peer.strip().lower()
        result: list[dict[str, Any]] = []
        for thread in self._threads.values():
            for env in thread.envelopes:
                if (
                    env.recipient.lower() == peer
                    and env.env_id in self._outbox.get(peer, [])
                    and env.env_id not in self._acked
                ):
                    result.append(
                        {"thread_id": thread.thread_id, **env.to_dict()}
                    )
        result.sort(key=lambda item: item["created_at"])
        return result

    # -- mutations -----------------------------------------------------------
    async def post(
        self,
        *,
        thread_id: str,
        kind: str,
        sender: str,
        recipient: str,
        body: dict[str, Any],
        scope: str = "",
        title: str = "",
    ) -> dict[str, Any]:
        kind = kind.strip().lower()
        sender = sender.strip().lower()
        recipient = recipient.strip().lower()
        thread_id = thread_id.strip()
        if kind not in VALID_ENVELOPES:
            return {"ok": False, "error": f"kind must be one of {VALID_ENVELOPES}"}
        if sender not in VALID_PEERS:
            return {"ok": False, "error": f"sender must be one of {VALID_PEERS}"}
        if recipient not in VALID_PEERS:
            return {"ok": False, "error": f"recipient must be one of {VALID_PEERS}"}
        if not thread_id:
            return {"ok": False, "error": "thread_id is required"}
        if not isinstance(body, dict):
            return {"ok": False, "error": "body must be an object"}

        thread = self._threads.get(thread_id)
        if thread is None:
            if kind not in {"propose", "critique"}:
                return {
                    "ok": False,
                    "error": f"cannot {kind} on a new thread; start with propose",
                }
            thread = Thread(thread_id=thread_id, title=title or thread_id)
            self._threads[thread_id] = thread
        elif thread.state in TERMINAL:
            return {
                "ok": False,
                "error": f"thread {thread_id} is {thread.state}; start a new thread",
            }

        env = Envelope(
            env_id=f"env-{uuid.uuid4().hex[:12]}",
            kind=kind,
            sender=sender,
            recipient=recipient,
            body=body,
            scope=scope,
        )
        thread.envelopes.append(env)
        thread.updated_at = env.created_at
        if env.env_id not in self._outbox[recipient]:
            self._outbox[recipient].append(env.env_id)
        self._persist()
        await self._notify()
        return {
            "ok": True,
            "thread_id": thread_id,
            "env_id": env.env_id,
            "state": thread.state,
            "message": f"{sender} {kind} -> {recipient} on {thread_id}",
        }

    async def ack(self, peer: str, env_id: str) -> dict[str, Any]:
        peer = peer.strip().lower()
        env_id = env_id.strip()
        if peer not in VALID_PEERS:
            return {"ok": False, "error": f"peer must be one of {VALID_PEERS}"}
        found = env_id in self._outbox.get(peer, [])
        if not found:
            return {"ok": False, "error": "envelope not found in peer outbox"}
        self._acked.add(env_id)
        self._outbox[peer] = [
            eid for eid in self._outbox[peer] if eid != env_id
        ]
        self._persist()
        await self._notify()
        return {"ok": True, "acked": env_id}