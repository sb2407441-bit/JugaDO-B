# Human AI — Governed AI Operating System

**Human AI** (formerly OpenWorker) is a governed AI operating system built on a local-first runtime. It operates as a virtual company with specialist AI departments that collaborate through structured handoffs, approval gates, and a quality-gated delivery pipeline. Every task enters a systematic funnel: Intake → Triage → Route → Plan → Build → QA → Deliver → Learn. Bring your own model keys and tools — everything runs locally on your machine.

## What's Running

| Layer | What it is | Status |
|---|---|---|
| **Human AI runtime** | Python agent engine, approval gates, connectors, memory, MCP | Active |
| **Agency Specialists** | 270+ role personas across 14 departments | Active |
| **Corporate OS** | Intake funnel, routing, quality gates, handoff protocol | Active |
| **OmniRoute** | Free token routing (290+ providers, ~1.53B tokens/mo) | Active |
| **Agent Reach** | Approval-gated internet research | Connected |
| **gstack** | Engineering delivery discipline | Connected |
| **Context7** | Current library/API documentation | Connected |
| **HyperFrames** | Video/motion production | Connected |
| **Cognee** | AI memory & knowledge graph | Adapter-ready |
| **browser-use** | AI browser automation | Adapter-ready |
| **strix** | AI security testing | Adapter-ready |
| **voicebox** | Voice I/O & narration | Adapter-ready |

## Quick Start

### Prerequisites
- Python 3.10+
- Node 20+
- (Optional) Rust toolchain via [rustup](https://rustup.rs/) for desktop shell

### Run from Source

```shell
git clone https://github.com/sb2407441-bit/JugaDO-B
cd JugaDO-B

# 1. Bootstrap Python venv (Windows: run from Git Bash or WSL)
bash packaging/setup_dev_env.sh

# 2. Start OmniRoute gateway (port 20128) - required for auto-router
cd D:\Resources\OmniRoute
npm run dev

# 3. Start Human AI server (port 8765)
cd D:\JugaDO-B
.venv\Scripts\python.exe -m coworker.server.run --cwd D:\JugaDO-B --port 8765

# 4. Start GUI (Vite dev server on port 5175)
cd surfaces\gui
npm install
npm run dev
```

Open `http://localhost:5175` — the GUI connects to the server on 8765 and OmniRoute on 20128.

### Architecture

```
┌────────────────────────────────────────────────┐
│              Human AI Desktop App              │  React UI + Tauri shell
├────────────────────────────────────────────────┤
│           Local Agent Server (Python)          │  Engine · Tools · Connectors
├───────────────┬────────────────┬───────────────┤
│  Your Files   │   Your Tools   │  Your Model   │  Everything runs with YOUR keys,
│  & Terminal   │ 25+ Connectors │  Any Provider │  on YOUR machine
└───────────────┴────────────────┴───────────────┘
```

## Key Features

### 🤖 Auto-Router with Free-Tier Fallback
- **OmniRoute** (290+ providers) with auto-combos: `auto/best-free`, `auto/coding`, `auto/reasoning`, `auto/fast`, `auto/chat`
- **LLM7** keyless gateway (no signup, `Bearer keyless` works)
- **SambaNova** free tier (DeepSeek-V3.2, Llama-3.3-70B, GPT-OSS-120B)
- **Size guard** skips Groq for prompts >7000 tokens (avoids 413)
- **Tool-call sanitization** fixes HF Gateway duplicate-ID bug (400 → works)

### 🎯 Governed Delivery Pipeline
```
INTAKE → TRIAGE → ROUTE → PLAN → BUILD → QA → DELIVER → LEARN
```
- Every task has **one accountable owner**
- **Approval gates** before consequential actions
- **Small reversible steps** — ten verified steps over one leap
- **Quality gates** per task type (code, research, content, data, security, infra)

### 🏢 Virtual Agency (270+ Specialists)
14 departments with 270+ role personas:
- **Software Delivery** — gstack Delivery Director, Senior Developer, Code Reviewer
- **Technical Documentation** — Context7 Technical Librarian, Technical Writer
- **Research** — Agent Reach Researcher, Trend Researcher
- **Security & Privacy** — Security Architect, Privacy Engineer, Penetration Tester
- **Data & Reporting** — Data Engineer, Analytics Reporter, Data Visualization Engineer
- **Growth & Business** — Business Strategist, Growth Hacker, Proposal Strategist
- **Operations** — Operations Manager, FinOps Engineer
- **Frontend & Design** — Frontend/Design Lead, UI Designer, UX Architect
- **Browser Automation** — Browser Automation Lead, Evidence Collector
- **SEO & Content** — SEO Specialist, Content Creator, Growth Lead
- **GIS & Spatial** — Geospatial Lead
- **Voice & Media** — Voice/Media Lead, HyperFrames Producer
- **Platform & Cost** — Platform Architect, FinOps Engineer

### 🔧 25+ Connectors
GitHub, Slack, Jira, Notion, Linear, HubSpot, Outlook, monday.com, Gmail, Google Calendar, MCP servers, and more — with per-tool approval control.

## Governance Files

| File | Purpose |
|---|---|
| `AGENTS.md` | Master workspace config — read at startup |
| `corporation/TEAM.md` | Active roster, roles, load triggers |
| `corporation/ROUTING.md` | Domain-to-persona routing table |
| `corporation/OPERATING_SYSTEM.md` | Professional delivery funnel |
| `corporation/HANDOFF_PROTOCOL.md` | Handoff brief format and rules |
| `corporation/QUALITY_GATES.md` | Per-task-type quality checklists |
| `corporation/COLLABORATION.md` | Task patterns and team norms |
| `INTEGRATIONS.md` | Integration catalog and activation guides |
| `RESOURCE_SETUP.md` | D:\Resources store setup |
| `DEPLOYMENT_RISKS.md` | Deployment errors, logical issues, runbooks |

## Model Routing (Default Chain)

```
omniroute:auto/best-free → llm7:gemini-3.1-flash-lite → gemini:gemini-3.6-flash → 
groq:llama-3.3-70b-versatile → llm7:codestral-latest → mistral:mistral-large-latest
```

- **OmniRoute** auto-combos pick best available model per task
- **LLM7** keyless — no signup, native tool-calling verified
- **Gemini/Groq/Mistral** — your keys, fallbacks when free tiers exhaust
- **Size guard** — prompts >7000 tokens skip Groq (avoids 413)

## Privacy

**Local-first.** Everything lives on your machine:
- Agent loop, conversations, connector tokens, model keys → local secret store
- Only cloud piece: small OAuth broker for connectors (optional — manual keys work)
- Use without signing in — manual credentials/API keys for all connectors

## Run from Source (Full)

```shell
git clone https://github.com/sb2407441-bit/JugaDO-B
cd JugaDO-B

# 1. Bootstrap Python venv (Windows: Git Bash or WSL)
bash packaging/setup_dev_env.sh

# 2. Start OmniRoute gateway (keep running)
cd D:\Resources\OmniRoute
npm run dev  # Port 20128

# 3. Start Human AI server
.venv\Scripts\python.exe -m coworker.server.run --cwd D:\JugaDO-B --port 8765

# 4. Start GUI
cd surfaces\gui
npm install
npm run dev  # http://localhost:5175
```

**Desktop app** (instead of browser UI): `npm run tauri dev` from `surfaces/gui/`

## Tests

```shell
# Backend
.venv\Scripts\pytest tests/ -q

# GUI unit + e2e
cd surfaces\gui
npm test
npm run e2e
```

## Repository Layout

| Directory | What's in it |
|---|---|
| `coworker/` | Python backend - agent engine, model providers, connectors, MCP client, memory, automations |
| `surfaces/gui/` | Desktop app - React UI + Tauri shell |
| `stt/` | Speech-to-text sidecar (Rust) for voice input |
| `packaging/` | Installer builds (macOS DMG, Windows), auto-update manifest |
| `corporation/` | Governance files (TEAM, ROUTING, OS, HANDOFF, QUALITY_GATES) |
| `tests/` | Backend test suite |
| `personas/` | 270+ specialist persona definitions |

## Built on aisuite

Human AI's engine is built on [**aisuite**](https://github.com/andrewyng/aisuite) — a lightweight Python library providing a unified chat-completions API across LLM providers and an agents layer with tools, toolkits, and MCP support.

## Contributing

Contributions and bug reports welcome — open an [issue](https://github.com/sb2407441-bit/JugaDO-B/issues) or PR. The app updates itself, so fixes reach installs quickly. For PRs, attach screenshots of the bug and fix.

## License

MIT — see [LICENSE](LICENSE).

---

**Human AI** — AI that gets your everyday tasks done. An open-source AI coworker that lives on your desktop and delivers **finished work**, not just chat.