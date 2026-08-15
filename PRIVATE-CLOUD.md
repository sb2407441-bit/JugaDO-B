# Human AI Private Control Plane

Human AI can run as a private corporate control plane on the Human AI laptop. Hermes is the
front-door coordinator; it submits tasks over the authenticated LAN API.

## Endpoint

```text
http://human-ai.local:8765/v1/corporate/tasks
```

Use the Human AI sidecar token as `Authorization: Bearer <token>` or
`x-openworker-token: <token>`.

## Submit a task

```json
{
  "message": "Create a short status report and save it in the task workspace.",
  "agent": "cowork",
  "model": "omniroute:oc/nemotron-3-ultra-free",
  "sender_id": "hermes"
}
```

The response contains `task_id`/`session_id`. Poll:

```text
GET /v1/corporate/tasks/{task_id}
```

The status response includes messages, pending approvals, and artifacts. Resolve an approval with:

```text
POST /v1/corporate/tasks/{task_id}/resolve
{"item_id":"...","resolution":"allow"}
```

The bridge uses Human AI's normal approval, inbox, workspace, persona, and artifact controls. It
does not expose the Hermes laptop's filesystem. Shared files require an explicit SMB/SSH/Tailscale
workspace setup.

## Privacy

The legacy OpenWorker Cloud sign-in is optional and currently disconnected. Cloud telemetry is
disabled. Local files remain on the Human AI laptop unless a task or model provider receives their
content explicitly.
