# Resource setup

The resource store is `D:\Resources`; the working product is `D:\OPENWORKER`. Keep source
repositories in the store and connect them through adapters in this workspace.

Run a read-only inventory:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\resource-health.ps1
```

Use [corporation/RESOURCE-CAPABILITY-MAP.md](corporation/RESOURCE-CAPABILITY-MAP.md) to decide
which repository belongs to a task. The machine-readable registry is
[corporation/RESOURCE_CATALOG.json](corporation/RESOURCE_CATALOG.json); it records whether a
resource is connected, optional, reference-only, or reserved.

HyperFrames is available through the enabled **HyperFrames Producer** persona. Its CLI wrapper is
`.\scripts\hyperframes.cmd`; HyperFrames requires Node.js 22+ and FFmpeg for rendering. The team
should check those prerequisites before installing anything. The HyperFrames workflow follows
the skill's visual-identity, deterministic-timeline, lint/inspect, preview, and render gates.

This layout is intentionally not a bulk copy of every resource. A department loads the smallest
useful adapter, keeps the source in the store, and records durable decisions in `corporation/`.
