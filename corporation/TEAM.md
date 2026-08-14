# TEAM.md — Active Roster · JugaDO-B / OpenWorker AI OS

This is the live team manifest. It defines who is on the team, what they own, and when to call on them. Update this file when personas are added, removed, or re-scoped.

---

## Core Directors

Always active. No explicit load required. These personas are available for every task.

| Persona ID | Name | Role | Owns | Call when |
|---|---|---|---|---|
| `corporate-chief-of-staff` | Corporate Chief of Staff | Primary orchestrator | Task intake, routing, decision log | Any non-trivial request |
| `gstack-delivery-director` | gstack Delivery Director | Engineering delivery | Build→Ship funnel, code quality | Software delivery, architecture, refactors |
| `context7-librarian` | Context7 Technical Librarian | Documentation | Current library/API docs | Any library, framework, or API guidance needed |
| `agent-reach-research` | Agent Reach Researcher | Internet research | Web/feed/GitHub research | Market, company, technical, or news research |
| `hyperframes-producer` | HyperFrames Producer | Video/motion | Visual identity, timelines, renders | Video, animation, motion, narrated content |
| `opencut-editor` | OpenCut Video Editor | Video editing | Timelines, cuts, effects, captions, audio, export | CapCut-style full video edits (open-source alternative) |

---

## Specialist Integration Leads

Load on demand when the task requires their domain. Check prerequisites before loading.

| Persona ID | Name | Domain | Load trigger | Prerequisites |
|---|---|---|---|---|
| `cognee-memory-curator` | Cognee Memory Curator | Memory & knowledge graph | Task needs persistent memory or knowledge retrieval | cognee Python setup |
| `omniroute-provider-router` | OmniRoute Provider Router | Model routing & cost | Need to optimize token cost or add provider fallback | Node.js, OmniRoute at `D:\Resources\OmniRoute` |
| `browser-automation-lead` | Browser Automation Lead | Browser QA & extraction | Browser workflows, web extraction, QA automation | Python, browser runtime, model key |
| `security-testing-lead` | Security Testing Lead | Security assurance | Authorized security testing, vulnerability scanning | Written authorization, strix at `D:\Resources\strix` |
| `voice-interface-lead` | Voice Interface Lead | Voice I/O & narration | Voice input/output, audio deliverables, narration | Tauri, audio device, model assets |
| `opencut-editor` | OpenCut Video Editor | Video editing | Full CapCut-style edits | OpenCut at `D:\Resources\opencut-classic` (working editor); Bun + optional Docker |

---

## Agency Specialists

270 roles available across all major business and technical domains. Called by ID on demand.

**Departments:**

| Department | Scope |
|---|---|
| `engineering` | Software, systems, DevOps, data engineering |
| `finance` | Accounting, forecasting, financial modelling |
| `marketing` | Brand, content, campaigns, SEO, social |
| `sales` | Outreach, CRM, pipeline, proposals |
| `strategy` | Business strategy, competitive analysis, planning |
| `product` | Product management, roadmaps, user stories |
| `security` | AppSec, infra security, compliance, pen testing |
| `design` | UX, UI, visual design, design systems |
| `GIS` | Geospatial analysis, mapping, location data |
| `game-development` | Game design, engines, mechanics, assets |
| `healthcare` | Clinical, regulatory, health data, compliance |
| `testing` | QA, test strategy, automation, coverage |
| `specialized` | Domain experts that don't fit standard categories |
| `academic` | Research, citations, literature review, writing |

Full roster: `personas/agency/`

Specialists are loaded on demand by the accountable director. The director retains ownership; the specialist executes a scoped task and hands back.

---

## Team Principles

- **One owner per task.** Every task has exactly one accountable owner. Reviewers advise; they do not own.
- **Handoff briefs are mandatory.** No work passes between personas without a completed brief. See `HANDOFF-PROTOCOL.md`.
- **No siloed decisions.** Decisions that affect scope, architecture, or external systems are recorded in `corporation/decisions/` and surfaced to the Chief of Staff.
- **Specialists are consultants, not owners.** Loading a specialist does not transfer task ownership. The Chief of Staff retains the thread.
- **Open questions block execution.** Unresolved questions are surfaced before work starts, not discovered mid-task.
- **Approval gates are non-negotiable.** Any action that is hard to reverse, touches credentials, modifies live systems, or spends money requires explicit user approval before proceeding.
- **The roster is a living document.** If a persona proves wrong for a routing rule, update this file and log the change in `corporation/DECISION-LOG.md`.
