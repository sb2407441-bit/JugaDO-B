"""P6 gate tests — two-coworker coordination broker (protocol + REST)."""

from __future__ import annotations

import json

import pytest
from fastapi.testclient import TestClient

from coworker.server import SessionManager, create_app
from coworker.server.coordinator import Coordinator, Envelope, Thread


# -- Coordinator unit tests ---------------------------------------------------


@pytest.mark.asyncio
async def test_coordinator_full_decision_flow(tmp_path):
    seen: list[dict] = []

    async def broadcaster(message):
        seen.append(message)

    coord = Coordinator(tmp_path, broadcaster=broadcaster)

    # propose
    r = await coord.post(
        thread_id="deploy-2026",
        kind="propose",
        sender="hermes",
        recipient="human-ai",
        body={"action": "rollout", "env": "staging"},
        title="Deploy staging",
    )
    assert r["ok"] is True
    assert r["state"] == "open"

    # critique
    r = await coord.post(
        thread_id="deploy-2026",
        kind="critique",
        sender="human-ai",
        recipient="hermes",
        body={"concern": "add rollback"},
    )
    assert r["ok"] is True
    assert r["state"] == "open"

    # decision
    r = await coord.post(
        thread_id="deploy-2026",
        kind="decision",
        sender="hermes",
        recipient="human-ai",
        body={"approved": True, "rollback": "git revert"},
    )
    assert r["ok"] is True
    assert r["state"] == "decided"

    # execute
    r = await coord.post(
        thread_id="deploy-2026",
        kind="execute",
        sender="human-ai",
        recipient="hermes",
        body={"status": "running"},
    )
    assert r["ok"] is True
    assert r["state"] == "open"  # execute is not terminal; last kind drives state

    # report (terminal)
    r = await coord.post(
        thread_id="deploy-2026",
        kind="report",
        sender="human-ai",
        recipient="hermes",
        body={"status": "done"},
    )
    assert r["ok"] is True
    assert r["state"] == "report"

    # terminal threads reject further envelopes
    r = await coord.post(
        thread_id="deploy-2026",
        kind="critique",
        sender="hermes",
        recipient="human-ai",
        body={"late": True},
    )
    assert r["ok"] is False

    assert coord.thread("deploy-2026")["state"] == "report"
    assert len(seen) == 5  # every mutation broadcast once


@pytest.mark.asyncio
async def test_coordinator_outbox_ack(tmp_path):
    coord = Coordinator(tmp_path)
    await coord.post(
        thread_id="t2",
        kind="propose",
        sender="hermes",
        recipient="human-ai",
        body={"msg": "hello"},
    )
    outbox = coord.outbox("human-ai")
    assert len(outbox) == 1
    env_id = outbox[0]["env_id"]

    # ack removes it from the recipient outbox
    r = await coord.ack("human-ai", env_id)
    assert r["ok"] is True
    assert coord.outbox("human-ai") == []

    # sender never sees their own message in their outbox
    assert coord.outbox("hermes") == []


@pytest.mark.asyncio
async def test_coordinator_validation(tmp_path):
    coord = Coordinator(tmp_path)
    assert (await coord.post(
        thread_id="x", kind="nope", sender="hermes", recipient="human-ai", body={}
    ))["ok"] is False
    assert (await coord.post(
        thread_id="x", kind="decision", sender="hermes", recipient="human-ai", body={}
    ))["ok"] is False  # cannot decide on a new thread
    assert (await coord.post(
        thread_id="x", kind="propose", sender="ghost", recipient="human-ai", body={}
    ))["ok"] is False  # invalid sender


@pytest.mark.asyncio
async def test_coordinator_persistence(tmp_path):
    coord = Coordinator(tmp_path)
    await coord.post(
        thread_id="persist-me",
        kind="propose",
        sender="hermes",
        recipient="human-ai",
        body={"n": 1},
    )
    reloaded = Coordinator(tmp_path)
    t = reloaded.thread("persist-me")
    assert t is not None
    assert t["envelopes"][0]["body"] == {"n": 1}


# -- REST endpoint tests ------------------------------------------------------


def _client(tmp_path):
    manager = SessionManager(workspace=tmp_path)
    return TestClient(create_app(manager))


def test_peers_rest_flow(tmp_path):
    client = _client(tmp_path)

    # propose over REST
    r = client.post(
        "/v1/peers/messages",
        json={
            "thread_id": "rest-thread",
            "kind": "propose",
            "sender": "hermes",
            "recipient": "human-ai",
            "body": {"topic": "latency"},
            "title": "Latency fix",
        },
    )
    assert r.status_code == 200
    assert r.json()["ok"] is True

    # outbox poll
    out = client.get("/v1/peers/outbox?peer=human-ai")
    assert out.status_code == 200
    assert len(out.json()["messages"]) == 1

    # reply (critique)
    r = client.post(
        "/v1/peers/messages",
        json={
            "thread_id": "rest-thread",
            "kind": "critique",
            "sender": "human-ai",
            "recipient": "hermes",
            "body": {"suggestion": "stream"},
        },
    )
    assert r.json()["ok"] is True
    assert len(client.get("/v1/peers/outbox?peer=hermes").json()["messages"]) == 1

    # threads list
    threads = client.get("/v1/peers/threads").json()["threads"]
    assert len(threads) == 1
    assert threads[0]["thread_id"] == "rest-thread"
    assert len(threads[0]["envelopes"]) == 2

    # ack
    env_id = client.get("/v1/peers/outbox?peer=hermes").json()["messages"][0]["env_id"]
    ack = client.post(f"/v1/peers/outbox/{env_id}/ack", json={"peer": "hermes"})
    assert ack.json()["ok"] is True
    assert client.get("/v1/peers/outbox?peer=hermes").json()["messages"] == []