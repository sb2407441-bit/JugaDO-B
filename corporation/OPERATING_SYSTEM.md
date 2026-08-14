# OpenWorker Corporation Operating System

## Operating model

OpenWorker is the execution owner: it holds workspace access, approvals, session history,
connectors, and deliverables. The Agency roster supplies specialist judgment. gstack supplies
the engineering delivery discipline. Agent Reach supplies internet-channel diagnostics and public
research. Context7 supplies version-aware technical documentation when explicitly connected.

No layer silently overrides another: user authority and OpenWorker approvals are final.

## The professional funnel

1. **Intake** — state the desired outcome, stakeholders, constraints, deadline, and acceptance criteria. The Chief of Staff captures the request verbatim and confirms success criteria before any work begins.
2. **Triage** — classify work as quick, standard, or consequential; identify privacy, money, production, legal, and dependency risk. High-risk tasks are flagged immediately and held for explicit user approval before proceeding.
3. **Route** — appoint one accountable owner plus only the specialist reviewers necessary for the risk. Routing follows `corporation/ROUTING.md`; integration leads are loaded on demand per `corporation/TEAM.md`.
4. **Plan** — create a short plan, decision record, dependencies, rollback path, and testable definition of done. Medium- and high-risk plans are shown to the user for approval before execution begins.
5. **Research** — use Context7/current primary docs for library decisions; use Agent Reach only for approved public-internet research. Explorer agents are read-only and return summaries only — they do not write files or call APIs.
6. **Build** — make small, reversible changes. Keep context compact by delegating independent, read-only exploration only. Any deviation from the approved plan triggers a new approval gate before continuing.
7. **Quality gate** — run appropriate review: architecture, security, accessibility, tests, data validation, or operations. A specialist reviewer signs off only when their domain is materially at risk; pass/fail evidence is recorded.
8. **Deliver** — provide the actual artifact, verification evidence, residual risks, and a clear next owner. State known limits and open risks explicitly so the next owner can act without re-investigation.
9. **Learn** — record reusable lessons in `corporation/decisions/` without storing secrets or personal data. Update routing rules or persona files if a routing decision proved wrong.

## Collaboration mechanics

Effective multi-persona work requires explicit handoffs, quality gates, and clear task patterns.

- **Handoff briefs are mandatory** for any task that crosses session or persona boundaries — see `corporation/HANDOFF-PROTOCOL.md` for the required format and fields.
- **Quality gates are mandatory** before any artifact is marked delivered — see `corporation/QUALITY-GATES.md` for gate types and sign-off criteria.
- **Team roster and load triggers** — the full team roster, always-active directors, and on-demand integration lead load conditions are defined in `corporation/TEAM.md`.
- **Task patterns** — choose the right collaboration shape for the work: Solo, Lead+Reviewer, Serial Chain, Swarm, or Director-Led. Definitions and selection criteria are in `corporation/COLLABORATION.md`.
- **Decision log** — significant decisions are recorded one file per decision in `corporation/decisions/`. No secrets or personal data are stored there.
- **Handoff storage** — cross-session task briefs are stored in `corporation/handoffs/` so any session can resume without re-investigation.

## Integration loading

Optional integrations (cognee, OmniRoute, browser-use, strix, voicebox) are loaded on demand per `corporation/RESOURCE_CATALOG.json`. No integration is started silently or globally installed without user approval.

Loading procedure:
1. Verify the source exists at `D:\Resources\[id]`.
2. Check all prerequisites listed in the catalog entry and `corporation/RESOURCE-CAPABILITY-MAP.md`.
3. Propose the setup steps to the user for explicit approval before taking any action.
4. Confirm the integration is operational and the persona is responsive before first use in a task.

## Scale rules

- One accountable owner; one delivery plan; one definition of done.
- A swarm is justified only for independent research or clearly separable artifacts. Consolidate into one review before execution.
- Cap routine work at three specialist reviewers. Escalate only when evidence demands it.
- Child explorers are read-only and return summaries; they preserve the main session's context.
- No automated commits, deployments, purchases, credential use, browser logins, or system-wide installs.
