# Dependency and capability governance

## Default

Investigate first. A new dependency is justified only when built-in tools and current installed
packages cannot meet a documented requirement.

## Required approval record

Before installation, capture: purpose, source/repository, version or revision, license/security
considerations, scope (workspace environment vs. system), expected files/network access, test,
and rollback command. Prefer the project `.venv` or project-local tool directory.

## Prohibited without explicit user approval

- system-wide package managers or PATH edits
- browser extensions, social login, cookie import/export, or credentials
- MCP server registration and remote endpoints
- background daemons, deployment, commits, pushes, payments, and destructive commands

## After any approved install

Run the narrow health check, record the installed version, verify one intended use, and report
what remains unavailable. Never claim a channel works merely because a package installed.

---

## Approval record 2026-08-14: @playwright/mcp v0.0.79

- **Purpose:** Agent-driven browser control in OpenCode for interactive signups/flows where the user manually solves CAPTCHAs (clicks, tab-opening, scrolling, finding, typing automated; CAPTCHA done by user).
- **Source/repository:** npm @playwright/mcp@0.0.79 (Playwright/Microsoft).
- **Version:** pinned 0.0.79, installed global npm root (%USERPROFILE%\AppData\Roaming\npm\node_modules\@playwright\mcp).
- **License/security:** Apache-2.0; launches Edge locally (--browser msedge), headed; --save-session persists local browser profile only.
- **Scope:** OpenCode global config (~/.config/opencode/opencode.jsonc), MCP server playwright. User-approved (option: Playwright MCP + Edge).
- **Access:** Controls local Edge; network access = whatever the user navigates to. No credentials handled by the agent; user pastes API keys/solves CAPTCHAs directly.
- **Test:** server starts and listens (stdio + port smoke tests pass); Edge channel is Playwright-supported; browser spawns lazily on first navigation after OpenCode restart.
- **Rollback:** remove the `"playwright"` block from ~/.config/opencode/opencode.jsonc (backup: opencode.jsonc.bak); uninstall 
pm uninstall -g @playwright/mcp.
- **Limits:** opencode must be restarted for MCP tools to appear; some sites detect automation; session profile may be reused by later sessions.

---

## Approval record 2026-08-14: OpenCut + OpenCut Classic (video editing)

- **Purpose:** Give the OpenWorker agency / JugaDO-B a full CapCut-style video editor — timeline edits, cutting/trimming, transitions, effects, captions, audio, and export — as a free open-source alternative to CapCut.
- **Source/repository:** github.com/opencut-app/opencut (rewrite, 82.8k stars) and github.com/opencut-app/opencut-classic (working editor today).
- **Version:** shallow clones (depth 1) into the resource store — opencut `400f097` (2026-08-01), opencut-classic `cf5e79e` (2026-05-17). MIT license.
- **License/security:** MIT. Media and project files treated as untrusted data; no external downloads, uploads, or accounts required.
- **Scope:** Resource store only (`D:\Resources\opencut`, `D:\Resources\opencut-classic`). No installs ran yet — `bun install` + optional Docker for classic are user-approved prerequisites before the first edit; no system-wide changes.
- **Access:** Local editor (web app on http://localhost:3005 for classic). No credentials handled; media stays on-device.
- **Test:** Both clones verified present with valid `.git` and HEAD commits; catalog JSON parses.
- **Rollback:** delete `D:\Resources\opencut` / `D:\Resources\opencut-classic`; remove the opencut entries from `RESOURCE_CATALOG.json` and the `opencut-editor` row from `INTEGRATIONS.md` / `TEAM.md` / `ROUTING.md`.
- **Limits:** the rewrite (`opencut`) is not yet production-ready — Editor API, MCP server, and headless/automation mode are planned but unreleased. The classic tree is the working editor today.
