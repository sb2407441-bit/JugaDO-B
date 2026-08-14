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
| Full video editing (CapCut alternative) | `opencut` + `opencut-classic` | OpenCut Video Editor persona; classic is the working editor today |

## Adapter-ready — persona installed, prerequisites required

| Capability | Resource | OpenWorker connection | Prerequisites |
|---|---|---|---|
| Long-term memory & knowledge graph | `cognee` | Cognee Memory Curator persona | Python venv, cognee package, storage backend |
| Free model routing & provider fallback | `OmniRoute` | OmniRoute Provider Router persona | Node.js 18+, .env config, gateway startup |
| Browser QA, extraction & web workflows | `browser-use` | Browser Automation Lead persona | Python, browser binary, model API key |
| Authorized application security testing | `strix` | Security Testing Lead persona | Written authorization, Docker or Python env |
| Local voice I/O & narrated deliverables | `voicebox` | Voice Interface Lead persona | Tauri, Bun, audio device, model assets |
| Self-learning / improvement loop (native) | `scripts/self-improve.ps1` | Corporate Chief of Staff (loop runner) | None — reads `corporation/DECISION-LOG.md`, emits proposals |
| Self-improving agent stack | `recursive-improve`, `mem0`, `letta-code`, `letta` | Corporate Chief of Staff + SEO Lead | Explicit approval before pip/npm install or benchmark runs |

## Load on demand

| Department or need | Resources | Why it belongs |
|---|---|---|
| UI generation and component retrieval | `21st-dev-magic-mcp`, `shadcn-ui-mcp-server`, `npxskillui` | Give the frontend team reusable components and design-system extraction without globally installing MCP servers. |
| Frontend quality and visual direction | `frontend-design`, `design-taste-frontend`, `ui-ux-pro-max`, `claudedesignskills`, `awesomeskills`, `gsap-skills` | Curated instructions and patterns are loaded as task-specific references. |
| Backend/product delivery | `convex-agent-skills`, `vercel-agent-skills` | Pull in platform-specific delivery guidance only when the stack requires it. |
| Cost-aware model routing (reference) | `omniroute-ide-gateway` | IDE gateway configuration reference for OmniRoute setup. |
| SEO and growth | `D:\Resources\seo` store — `open-seo`, `open-seo-crawler`, `seobuild-onpage` (skill), `geo-optimizer-skill` (skill), `seo-geo-optimizer` (skill), `geo-aeo-tracker`, `seo-agent`, `seo-kit`, `seonaut`, `site-audit-seo`, `spider`, `seo-rank-tracker`; plus `public-apis`, `fb-automation` | Curated SEO/AEO/GEO tooling with external-write gates; skills already live in global OpenCode skills. Full index: `D:\Resources\seo\RESOURCE-INDEX.md` |
| Solar and energy | `solar-flair`, `solarnet-plus` | Supports solar-site analysis, resilience planning, and rooftop-potential research. |
| Spatial/3D products | `open-buildings`, `osmbuildings`, `maptalks-three`, `scroll-world` | Gives the GIS/visualization team mapping, building, and WebGL options. |

## Reference or reserved

- `awesome-cli-coding-agents` is a decision catalog, not another always-on agent runtime.
- `OpenManus` is an experimental autonomous runtime and stays isolated until a task explicitly
  requests it.

## Safe loading contract

1. The Chief of Staff routes a task to a department and names the needed capability. Load triggers and prerequisites for integration leads are defined in `corporation/TEAM.md`.
2. The health script verifies that the resource source exists and that required runtimes are present.
3. The department proposes an adapter or skill load; it does not silently install global software.
4. External writes, credentials, browser profiles, security scans, and model gateways require an
   explicit approval checkpoint.
5. The task records the selected resource, version/commit, inputs, outputs, and rollback path.

This keeps the product tree small while preserving a broad, inspectable capability surface.
