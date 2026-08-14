# Integration Catalog

OpenWorker integrations extend the core runtime with specialist capabilities. Each integration has a dedicated persona that acts as the single entry point — switch to that persona to activate the integration.

## Summary

| Integration | Persona ID | Status | Key capability |
|---|---|---|---|
| Agent Reach | agent-reach-research | connected | Web/feed/GitHub research |
| gstack | gstack-delivery-director | connected | Engineering delivery funnel |
| Context7 | context7-librarian | connected | Current library/API docs |
| HyperFrames | hyperframes-producer | connected | Video/motion production |
| OpenCut | opencut-editor | connected | Full video editing (open-source CapCut alternative) |
| Cognee | cognee-memory-curator | adapter-ready | Memory & knowledge graph |
| OmniRoute | omniroute-provider-router | adapter-ready | Free token routing, 290 providers (native auto-fallback now covers the "stable → others in order" need — see below) |
| browser-use | browser-automation-lead | adapter-ready | Browser QA & extraction |
| strix | security-testing-lead | adapter-ready | AI pentesting & vuln scanning |
| voicebox | voice-interface-lead | adapter-ready | Voice I/O & narration |
| eng0 Template Skills | opencode global skill | connected | Next.js/Awwwards template skills (awwwards-landing-page) |
| award-winning-website | opencode global skill | connected | Zentry-inspired Awwwards template (React + GSAP + Tailwind) |
| gsap-awwwards-website | opencode global skill | connected | GSAP Awwwards Site-of-the-Day template (React 19) |
| SEO/AEO/GEO store | opencode global skills + resource store | connected | SEO tooling + AI-search optimization (seobuild-onpage, geo-optimizer-skill, seo-geo-optimizer) |
| Self-improvement loop | scripts/self-improve.ps1 | connected | Mines decision log, proposes improvements (keep/revert) |

---

## Agent Reach

**What it does:** Gives the OpenWorker team a diagnosed, approval-gated route to public webpages, RSS feeds, YouTube, public GitHub repositories, and other optional internet channels. All outbound requests are gated — no silent browsing.

**Persona ID:** `agent-reach-research`
([personas/integrations/agent-reach-research.md](personas/integrations/agent-reach-research.md))

**How to activate:** Switch to the Agent Reach Researcher persona and describe the research task (URL, feed, GitHub repo, or topic). The persona runs the CLI only through OpenWorker's approval-gated shell.

**Prerequisites:** Agent Reach installed from `D:\Resources\agent-reach` into this project's `.venv`. The default installation does **not** install machine-wide tools, configure MCP servers, import cookies, or connect social accounts. Check available channels:

```powershell
.\scripts\agent-reach.cmd doctor --json
```

Only after an explicit administrator decision should Agent Reach's system setup or social-channel configuration be used — those steps may install external tools or depend on a user-owned browser login.

---

## gstack

**What it does:** Contributes the **Think → Plan → Build → Review → Test → Ship** engineering delivery discipline to OpenWorker. The gstack Delivery Director enforces structured delivery funnels, sprint planning, and code-review gates. OpenWorker continues to own tool execution and approvals.

**Persona ID:** `gstack-delivery-director`

**How to activate:** Switch to the gstack Delivery Director persona and describe the engineering task or delivery goal. It will apply the gstack discipline to scope, plan, and track the work.

**Prerequisites:** gstack vendored at `vendor/gstack`. Its CLI/browser runtime requires Bun and optional browser dependencies — it remains opt-in rather than an always-on process.

---

## Context7

**What it does:** Provides current, version-specific library and API documentation on demand. Context7 is the preferred source for up-to-date docs — it prevents the team from relying on stale training-data knowledge about library APIs.

**Persona ID:** `context7-librarian`

**How to activate:** Switch to the Context7 Technical Librarian persona and ask for documentation on a specific library, framework, or API version. The persona will connect to Context7 and return authoritative, version-pinned docs.

**Prerequisites:** Context7 vendored at `vendor/context7`. Connecting its remote MCP endpoint (`https://mcp.context7.com/mcp`) or running its Node-based CLI requires an explicit user-approved setup and, optionally, a Context7 API key. The persona never fabricates a successful Context7 connection.

---

## Corporation Operating System

**What it does:** The director personas and professional task funnel documented in `corporation/` form the governance backbone of JugaDO-B. This includes the intake funnel, routing table, quality gates, handoff protocol, and decision log.

**How to activate:** Switch to the **Corporate Chief of Staff** persona to engage the full governance system. Run the health check to validate the local runtime and all persona manifests:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\corporation-health.ps1
```

---

## HyperFrames

**What it does:** Connects OpenWorker to the HyperFrames video and motion production pipeline. The HyperFrames Producer persona scopes, plans, and executes video production tasks using the resource catalog and local scripts.

**Persona ID:** `hyperframes-producer`

**How to activate:** Switch to the HyperFrames Producer persona and describe the video or motion deliverable. It will check prerequisites and guide setup.

**Prerequisites:** See [RESOURCE-SETUP.md](RESOURCE-SETUP.md) for the resource-store boundary and prerequisite checks. Use `.\scripts\hyperframes.cmd` to interact with the pipeline.

---

## OpenCut

**What it does:** Connects OpenWorker to OpenCut — the free, open-source CapCut alternative — for full video editing: cutting/trimming, transitions, effects, text/captions, audio, and export. The OpenCut Video Editor persona scopes and executes edits using the resource store.

**Two source trees in the store:**
- `D:\Resources\opencut` — the current rewrite (Rust core, desktop + web + API apps). Editor API, plugin system, MCP server (for AI agents), headless/automation mode, and an in-editor scripting tab are planned but not yet released. Active development repo.
- `D:\Resources\opencut-classic` — the working editor today (what opencut.app runs). Next.js web app; use this for real edits until the rewrite ships its MCP/headless path.

**Persona ID:** `opencut-editor`
([personas/integrations/opencut-editor.md](personas/integrations/opencut-editor.md))

**How to activate:** Switch to the OpenCut Video Editor persona and describe the edit (source clips, timeline, effects, captions, audio, export format). It will confirm the runtime, check prerequisites, and run the edit against the working tree.

**Prerequisites:** Bun for `opencut-classic` (`bun install` + `bun dev:web` → http://localhost:3005); optional Docker for the local DB/Redis. The rewrite (`opencut`) uses proto/moon and is not yet production-ready — do not treat it as the daily editor until its headless/MCP path ships.

---

## Cognee Memory Curator

**What it does:** Cognee is the open-source AI Memory Platform at `D:\Resources\cognee`. It builds queryable knowledge graphs, stores episodic task memories, and enables cross-session knowledge retrieval — giving the OpenWorker team persistent, structured memory across conversations.

**Persona ID:** `cognee-memory-curator`

**How to activate:** Switch to the Cognee Memory Curator persona and ask it to index a topic, retrieve past decisions, or build a knowledge summary.

**Prerequisites:** Python 3.10+, cognee package installed in `.venv`, a storage backend (SQLite default). The persona will confirm prerequisites before acting.

---

## OmniRoute Provider Router

**What it does:** OmniRoute is the free AI gateway at `D:\Resources\OmniRoute`. It routes across 290+ providers, provides approximately 1.53B free tokens/month across stacked free tiers, and applies RTK+Caveman compression that saves 15–95% of tokens. It is the recommended gateway for cost-efficient model routing across the Agency.

**Persona ID:** `omniroute-provider-router`

**How to activate:** Switch to the OmniRoute Provider Router persona and ask it to configure the gateway, select a routing strategy, or estimate the free token budget.

**Prerequisites:** Node.js 18+, `.env` config with provider keys, gateway started (`npm run dev` or Docker). Run as a local service; connect OpenWorker's model config to the gateway endpoint.

---

## Browser Automation Lead

**What it does:** browser-use is the AI browser automation library at `D:\Resources\browser-use`. It lets agents control a browser for QA flows, data extraction, form workflows, and web research — all approval-gated before any write or submit action on an external site.

**Persona ID:** `browser-automation-lead`

**How to activate:** Switch to the Browser Automation Lead persona and describe the browser task (URL, actions, data targets). It will produce an approval-gated Python script using the browser-use library.

**Prerequisites:** Python, browser binary (Chrome/Chromium), model API key, explicit user approval before any write/submit action on an external site.

**Active alternative — Playwright MCP (recommended for interactive flows):** `@playwright/mcp@0.0.79` is registered as the `playwright` MCP server in `~/.config/opencode/opencode.jsonc`. It launches a headed **Edge** browser (`--browser msedge`) and gives the agent native browser tools in the running session (navigate, click, type, scroll, tabs, snapshots). `--save-session` persists the browser profile across calls. Flow for signups: agent drives the browser, pauses at CAPTCHA/login, user completes it manually, agent continues. Approval record + rollback: `corporation/DEPENDENCY-GOVERNANCE.md` (2026-08-14). Requires OpenCode restart to load MCP tools.

---

## Security Testing Lead

**What it does:** strix is the open-source AI pentesting tool at `D:\Resources\strix`. Autonomous AI agents find and fix application vulnerabilities. The Security Testing Lead scopes, runs, and reports on security tests — and will never scan without written authorization.

**Persona ID:** `security-testing-lead`

**How to activate:** Switch to the Security Testing Lead persona and provide a written authorization document (target system, test type, scope, rules of engagement). The persona will never scan without it.

**Prerequisites:** Written authorization on file, Docker or Python environment, strix installed from `D:\Resources\strix`. The persona will confirm scope and authorization before any scan starts.

---

## Voice Interface Lead

**What it does:** voicebox is the open-source AI voice studio at `D:\Resources\voicebox`. It supports voice cloning (with consent), speech generation, dictation, and local voice I/O — enabling voice-driven workflows and audio deliverables.

**Persona ID:** `voice-interface-lead`

**How to activate:** Switch to the Voice Interface Lead persona and describe the voice task (audio deliverable, dictation setup, voice cloning). For cloning, provide explicit named consent from the person being cloned.

**Prerequisites:** Tauri runtime, Bun/Node.js, audio device, model assets (may require download). The persona confirms prerequisites before setup.

---

## eng0 Template Skills

**What it does:** eng0 platform template skills — one directory per template (Next.js/Awwwards landing pages, AI apps, dashboards, Stripe, etc.) with `SKILL.md` setup and deploy instructions. The repo is stored at `D:\Resources\eng0-template-skills` (canonical source, kept out of the working product). The `awwwards-landing-page` skill is installed to OpenCode global skills so any project can trigger it.

**Persona ID:** none — the skill is registered with OpenCode's native `skill` tool (global install at `~/.agents/skills/awwwards-landing-page`).

**How to activate:** Ask the agent to build a designer-portfolio landing page with Locomotive Scroll / GSAP / Framer Motion. The skill auto-loads via OpenCode's `skill` tool.

**Prerequisites:** Node.js (project uses Next.js on port 3000); Vercel/Netlify tokens for deploy steps. Reinstall after pulling updates:

```powershell
npx skills add "D:\Resources\eng0-template-skills" --skill awwwards-landing-page -g -a opencode --copy -y
```

---

## award-winning-website

**What it does:** Zentry-inspired Awwwards-winning website template — scroll-based animations, clip-path shaped transitions, 3D hover effects, and video storytelling (React + Vite + GSAP + Tailwind). The full codebase is stored at `D:\Resources\award-winning-website` (canonical source); the `award-winning-website` skill is installed to OpenCode global skills.

**Persona ID:** none — registered with OpenCode's native `skill` tool (global install at `~/.agents/skills/award-winning-website`).

**How to activate:** Ask the agent to build a Zentry-style animated landing page. The skill auto-loads via OpenCode's `skill` tool.

**Prerequisites:** Node.js + npm (Vite dev server on port 5173). The template's assets/fonts belong to Zentry — replace before any commercial/public use. Reinstall after pulling updates:

```powershell
npx skills add "D:\Resources\award-winning-website" --skill award-winning-website -g -a opencode --copy -y
```

---

## gsap-awwwards-website

**What it does:** Awwwards Site-of-the-Day website template — parallax, clip-path magic, ScrollTrigger/ScrollSmoother, pinned sections, and Awwwards-style text reveal (React 19 + Vite + GSAP + Tailwind v4). The full codebase is stored at `D:\Resources\GSAP-Awwwards-Website` (canonical source); the `gsap-awwwards-website` skill is installed to OpenCode global skills.

**Persona ID:** none — registered with OpenCode's native `skill` tool (global install at `~/.agents/skills/gsap-awwwards-website`).

**How to activate:** Ask the agent to build a GSAP-powered immersive landing page. The skill auto-loads via OpenCode's `skill` tool.

**Prerequisites:** Node.js + npm (or yarn); Vite dev server. Media assets live under `public/videos`, `public/fonts`, `public/images` — bundle them when moving the project. Reinstall after pulling updates:

```powershell
npx skills add "D:\Resources\GSAP-Awwwards-Website" --skill gsap-awwwards-website -g -a opencode --copy -y
```

---

## SEO / AEO / GEO store

**What it does:** Curated SEO resource store at `D:\Resources\seo` (core / geo-aeo / self-improving), kept out of the working product. Three skills are installed globally to OpenCode: `seobuild-onpage` (on-page AEO/SEO page writing), `geo-optimizer-skill` (GEO audit + 47-method citability engine), `seo-geo-optimizer` (SEO/GEO/AEO audit: schema, metadata, keywords, IndexNow). Full index with tiers and activation gates: `D:\Resources\seo\RESOURCE-INDEX.md`.

**Persona ID:** none (skills register with OpenCode's native `skill` tool at `~/.agents/skills/`).

**How to activate:** Ask the agent to audit/optimize for search or AI-search visibility; the matching skill auto-loads. For heavier tools (open-seo, geo-aeo-tracker, seo-agent, crawlers), route through the Growth/SEO department and approval-gate external crawls and writes.

**Prerequisites:** Node.js for the installed skills' tooling; per-tool runtimes (Python/Docker/Cloudflare/DB) only when a routed task needs them and is approved.

---

## Self-improvement loop

**What it does:** A zero-install native loop (`scripts/self-improve.ps1`) that reads `corporation/DECISION-LOG.md`, extracts lessons (wins, failures, recurring risks, next-owner chains), and emits improvement proposals with keep/revert guidance. Heavier self-improving adapters are cloned and adapter-ready: `recursive-improve` (benchmark + keep/revert), `mem0` (memory layer), `letta-code` / `letta` (stateful agent runtime). Governance: `corporation/SELF-IMPROVEMENT.md`.

**Persona ID:** Corporate Chief of Staff (owns the loop).

**How to activate:** Run `.\scripts\self-improve.ps1` to produce `runtime-state\self-improve-report.md`. Apply only proposals that pass the approval gate; revert on regression (same keep/revert principle as recursive-improve).

**Prerequisites:** None for the native loop. The heavier adapters (mem0, letta, recursive-improve) require explicit approval before pip/npm install or benchmark runs.

---

## Free LLM APIs store

**What it does:** `D:\Resources\awesome-free-llm-apis` is a curated list of 134 permanent free-tier LLM APIs across 40+ providers (Gemini, Grok, NVIDIA, Groq, Cerebras, Mistral, etc.). Ships with a machine-readable `data.json` and an OpenCode skill (`free-llm-apis`, installed globally). Provider routing preference: OmniRoute for 290-provider routing; this store for direct free-tier endpoints.

**Persona ID:** none (skill registers with OpenCode's native `skill` tool at `~/.agents/skills/free-llm-apis`).

**Active wiring in the running OpenCode:**
- `llm7` provider (`https://api.llm7.io/v1`, OpenAI-compatible, keyless tier) added to `~/.config/opencode/opencode.jsonc` — models verified working free without signup: `gemini-3.1-flash-lite`, `codestral-latest`. More LLM7 models unlock with a free token at https://token.llm7.io (401/429 keyless).
- Key-based free providers (Groq, Cerebras, Mistral, Google Gemini, NVIDIA NIM, OpenRouter, Hugging Face, DeepSeek, Moonshot, etc.) are **native to OpenCode**: run `/connect` in the OpenCode TUI, search the provider, paste the free key → stored in `~/.local/share/opencode/auth.json`. No config file edit needed.
- Other OpenAI-compatible free endpoints (Zhipu GLM, 302.AI, Kluster AI, LLM7 with token) can be added as custom `@ai-sdk/openai-compatible` blocks on request.

**How to activate:** After any config change, restart OpenCode, then `/models` and pick the free provider/model. `/connect` is the preferred key path (keys never committed).

**Prerequisites:** None for the keyless LLM7 tier. Free API keys are user-provided via `/connect` or env vars; never paste keys into chat or commit them.

---

## Native provider auto-fallback router

**What it does:** OpenWorker's own provider router (`coworker/providers/router.py`) now treats a comma-separated model string as an ordered fallback chain — `stable,backup1,backup2` — tried left to right. The first candidate that answers wins; a candidate is skipped when it fails before producing anything (quota 402, rate-limit 429, 5xx, bad key, timeout). Streaming falls back only before the first chunk; mid-stream errors surface to the caller. This delivers the "start from the stable model, vary to others in order" auto-router behaviour with zero extra services.

**Current default (set 2026-08-14, live on server 8765):**
`gemini:gemini-3.6-flash,groq:llama-3.3-70b-versatile,mistral:mistral-large-latest`

**Free provider profiles configured in `%APPDATA%\coworker\secrets.json`:** `provider:openrouter`, `provider:groq`, `provider:cerebras`, `provider:mistral`, `provider:huggingface` (+ refreshed `provider:gemini`). Live `/models` counts: openrouter 411, groq 15, cerebras 3, mistral 55, huggingface 137.

**Known status (2026-08-14):** groq, mistral, huggingface routes verified live; openrouter and cerebras keys are valid but unpaid (402). OpenRouter `:free` models share an upstream pool that rate-limits (429).

**How to use:** Set a chain as the default model via `POST /v1/settings/default-model` `{"model": "a,b,c"}` or in the GUI model picker; any single model string still works exactly as before. See `corporation/DECISION-LOG.md` (2026-08-14 · free-model-providers-plus-autofallback) for evidence.

**Prerequisites:** A working key per provider in the chain. Unit coverage in `tests/test_provider_router.py` (fallback in order, stop at first success, all-fail raises last, first-chunk-wins streaming, mid-stream error surfacing).

