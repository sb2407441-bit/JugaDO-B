# Resource operating model

`D:\Resources` is the resource store. `D:\OPENWORKER` is the executable product workspace.
The team does not copy every resource into the workspace. It registers a source, adapter, skill,
runtime requirement, and health check, then loads only the relevant capability for a task.

## Registered capability layers

| Layer | Store source | Workspace connection | Best use |
|---|---|---|---|
| Agency Agents | `D:\Resources\agency-agents` | 270 manifests in `personas/agency` | Specialist departments |
| OpenWorker | `D:\Resources\openworker` | local backend/UI source | Execution, approvals, memory, connectors |
| Agent Reach | `D:\Resources\agent-reach` | `.venv` CLI + Researcher persona | Public web/RSS/social-channel diagnostics |
| gstack | `D:\Resources\gstack` | vendored source + Delivery Director | Think, plan, build, review, test, ship |
| Context7 | `D:\Resources\context7` | vendored source + Librarian persona | Current library/API documentation |
| HyperFrames | `D:\Resources\hyperframes` | Producer persona + CLI wrapper | Video, captions, motion, rendering |
| Cognee | `D:\Resources\cognee` | reserved memory adapter | Long-lived knowledge graph and recall |
| Design and frontend references | `D:\Resources\frontend-design`, `design-taste-frontend`, `ui-ux-pro-max`, `gsap-skills` | lazy skill/reference loading | UI quality, design systems, motion |
| Optional delivery adapters | `D:\Resources\21st-dev-magic-mcp`, `shadcn-ui-mcp-server`, `browser-use`, `strix` | approval-gated adapters | UI retrieval, browser QA, authorized security testing |
| Domain capability store | `D:\Resources\open-seo`, solar, geospatial, voice, and social repos | department-specific adapters | SEO, solar, maps, voice, and growth workflows |
| Runtime and routing experiments | `D:\Resources\OpenManus`, `OmniRoute` | isolated/reserved adapters | autonomous runtime experiments and model cost control |

## Loading rules

1. Match the task to a department and capability layer.
2. Run the relevant health check before claiming availability.
3. Load only the required skill/reference into the active context.
4. Use short handoff briefs between specialists.
5. Save durable decisions and artifacts under `corporation/decisions/` or a task deliverable.
6. Keep large repositories in `D:\Resources`; do not duplicate them into the product tree.
