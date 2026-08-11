# Optional capability layers

## Agent Reach

Agent Reach is installed from the local source at `D:\Resources\agent-reach` into this
project's `.venv`. It gives the OpenWorker team a diagnosed, approval-gated route to public
webpages, RSS, YouTube, public GitHub, and other optional internet channels.

The [Agent Reach Researcher](personas/integrations/agent-reach-research.md) persona is the
OpenWorker entry point. It may run the CLI only through OpenWorker's approval-gated shell.
The default installation does **not** install machine-wide tools, configure MCP servers, import
cookies, or connect social accounts.

Check the locally available channels:

```powershell
.\scripts\agent-reach.cmd doctor --json
```

Only after an explicit decision should an administrator use Agent Reach's system setup or a
specific social-channel configuration. Those steps may install external tools or depend on a
user-owned browser login.

## gstack

gstack is vendored at `vendor/gstack` and is represented in OpenWorker by the **gstack Delivery
Director**. It contributes the Think → Plan → Build → Review → Test → Ship discipline; OpenWorker
continues to own tool execution and approvals. Its CLI/browser runtime requires Bun and optional
browser dependencies, so it remains opt-in rather than an always-on process.

## Context7

Context7 is vendored at `vendor/context7` and represented by the **Context7 Technical Librarian**.
It is the preferred source for current, version-specific library/API documentation. Connecting its
remote MCP endpoint (`https://mcp.context7.com/mcp`) or running its Node-based CLI requires an
explicit user-approved setup and, optionally, a Context7 API key. The persona never fabricates a
successful Context7 connection.

## Corporation operating system

The director personas and professional task funnel are documented in `corporation/`. Run
`powershell -ExecutionPolicy Bypass -File .\scripts\corporation-health.ps1` to validate the local
runtime and all persona manifests.

HyperFrames is connected through the **HyperFrames Producer** persona, the resource catalog, and
`.\scripts\hyperframes.cmd`. See [RESOURCE-SETUP.md](RESOURCE-SETUP.md) for the resource-store
boundary and prerequisite checks.
