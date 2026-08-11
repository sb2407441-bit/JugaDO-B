# Resource capability map

This is the operating map for the repositories kept in `D:\Resources`. OpenWorker owns
coordination, approvals, personas, handoffs, and durable decisions. A resource is loaded only
when a routed task needs it; a catalog entry is not permission to run or install it.

## Connected now

| Capability | Resource | OpenWorker connection |
|---|---|---|
| Specialist departments | `agency-agents` | 270 enabled agency personas |
| Execution and approvals | `openworker` | local backend/UI and state |
| Web and feed research | `agent-reach` | CLI plus Researcher persona |
| Software delivery funnel | `gstack` | Delivery Director persona and vendored source |
| Current technical documentation | `context7` | Librarian persona and vendored source |
| Video and motion production | `hyperframes` | Producer persona and CLI wrapper |

## Load on demand

| Department or need | Resources | Why it belongs |
|---|---|---|
| UI generation and component retrieval | `21st-dev-magic-mcp`, `shadcn-ui-mcp-server`, `npxskillui` | Give the frontend team reusable components and design-system extraction without globally installing MCP servers. |
| Frontend quality and visual direction | `frontend-design`, `design-taste-frontend`, `ui-ux-pro-max`, `claudedesignskills`, `awesomeskills`, `gsap-skills` | Curated instructions and patterns are loaded as task-specific references. |
| Backend/product delivery | `convex-agent-skills`, `vercel-agent-skills` | Pull in platform-specific delivery guidance only when the stack requires it. |
| Browser QA and extraction | `browser-use` | Useful for controlled browser workflows; requires a browser runtime and approval. |
| Security assurance | `strix` | Useful for authorized testing; never run against a target without written scope. |
| Cost-aware model routing | `OmniRoute`, `omniroute-ide-gateway` | Optional gateway for provider fallback and token-cost control. |
| SEO and growth | `open-seo`, `public-apis`, `fb-automation` | SEO research, API discovery, and social operations are separate growth capabilities with external-write gates. |
| Solar and energy | `solar-flair`, `solarnet-plus` | Supports solar-site analysis, resilience planning, and rooftop-potential research. |
| Spatial/3D products | `open-buildings`, `osmbuildings`, `maptalks-three`, `scroll-world` | Gives the GIS/visualization team mapping, building, and WebGL options. |
| Voice interfaces | `voicebox` | Optional local voice input/output for agent interactions and narrated deliverables. |

## Reference or reserved

- `awesome-cli-coding-agents` is a decision catalog, not another always-on agent runtime.
- `OpenManus` is an experimental autonomous runtime and stays isolated until a task explicitly
  requests it.
- `cognee` is reserved for a durable memory adapter; it should not become a second source of
  truth until its storage, retention, and recovery policy is approved.

## Safe loading contract

1. The Chief of Staff routes a task to a department and names the needed capability.
2. The health script verifies that the resource source exists and that required runtimes are present.
3. The department proposes an adapter or skill load; it does not silently install global software.
4. External writes, credentials, browser profiles, security scans, and model gateways require an
   explicit approval checkpoint.
5. The task records the selected resource, version/commit, inputs, outputs, and rollback path.

This keeps the product tree small while preserving a broad, inspectable capability surface.
