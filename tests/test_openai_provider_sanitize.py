"""Regression: some compat backends (HF gateway) emit duplicate tool-call ids (`call_0` for
every call); once tool results ride the history, the next request is rejected ("Multiple tool
calls with the same id"). `_sanitize_messages` (outgoing) + `_unique_call_ids` (parsed) must
guarantee unique ids, and the router's size guard must skip small-limit free tiers up front.
"""

from __future__ import annotations


def _sanitize_messages(messages):
    from coworker.providers.openai_provider import _sanitize_messages as fn

    return fn(messages)


def _unique_call_ids(calls):
    from coworker.providers.openai_provider import _unique_call_ids

    return _unique_call_ids(calls)


def test_sanitize_dedupes_tool_ids_and_remaps_results():
    msgs = [
        {"role": "system", "content": "s"},
        {
            "role": "assistant",
            "content": None,
            "tool_calls": [
                {
                    "id": "call_0",
                    "type": "function",
                    "function": {"name": "write_file", "arguments": '{"p":"a"}'},
                },
                {
                    "id": "call_0",
                    "type": "function",
                    "function": {"name": "read_file", "arguments": '{"p":"b"}'},
                },
            ],
        },
        {"role": "tool", "tool_call_id": "call_0", "content": "ok1"},
        {"role": "tool", "tool_call_id": "call_0", "content": "ok2"},
        {"role": "assistant", "content": "done", "tool_calls": []},
    ]
    out = _sanitize_messages(msgs)
    ids = [tc["id"] for m in out if m["role"] == "assistant" for tc in (m.get("tool_calls") or [])]
    assert len(ids) == len(set(ids)) == 2  # duplicates gone
    first, second = ids
    assert first == "call_0"  # first occurrence keeps its id
    assert second.startswith("call_0_")  # second is renumbered deterministically
    results = {m["tool_call_id"] for m in out if m["role"] == "tool"}
    assert results == {first, second}  # tool messages remapped to the renumbered id


def test_sanitize_strips_foreign_sidecars_still():
    out = _sanitize_messages(
        [{"role": "user", "content": "hi", "_gemini": {"thought": "x"}}]
    )
    assert out == [{"role": "user", "content": "hi"}]


def test_unique_call_ids_renumbers_duplicates_and_empties():
    from coworker.providers.base import ToolCall

    calls = _unique_call_ids(
        [
            ToolCall(id="call_0", name="a", arguments={}),
            ToolCall(id="call_0", name="b", arguments={}),
            ToolCall(id="", name="c", arguments={}),
        ]
    )
    assert len({c.id for c in calls}) == len(calls) == 3
    assert calls[0].id == "call_0"
    assert calls[1].id.startswith("call_0_")
    assert calls[2].id  # empty id filled


def test_router_size_guard_skips_small_limit_provider():
    from coworker.providers.router import ProviderRouter, _estimate_input_tokens

    router = ProviderRouter()
    big = [{"role": "user", "content": "x" * 40_000}]  # ~10k tokens by the estimate
    assert _estimate_input_tokens(big, None) > 7000
    assert router._too_large("groq:llama-3.3-70b-versatile", big, None) is True
    assert router._too_large("llm7:gemini-3.1-flash-lite", big, None) is False
    small = [{"role": "user", "content": "hi"}]
    assert router._too_large("groq:llama-3.3-70b-versatile", small, None) is False
