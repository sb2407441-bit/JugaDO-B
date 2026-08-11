# OpenWorker Corporation Operating System

## Operating model

OpenWorker is the execution owner: it holds workspace access, approvals, session history,
connectors, and deliverables. The Agency roster supplies specialist judgment. gstack supplies
the engineering delivery discipline. Agent Reach supplies internet-channel diagnostics and public
research. Context7 supplies version-aware technical documentation when explicitly connected.

No layer silently overrides another: user authority and OpenWorker approvals are final.

## The professional funnel

1. **Intake** — state the desired outcome, stakeholders, constraints, deadline, and acceptance criteria.
2. **Triage** — classify work as quick, standard, or consequential; identify privacy, money, production, legal, and dependency risk.
3. **Route** — appoint one accountable owner plus only the specialist reviewers necessary for the risk.
4. **Plan** — create a short plan, decision record, dependencies, rollback path, and testable definition of done.
5. **Research** — use Context7/current primary docs for library decisions; use Agent Reach only for approved public-internet research.
6. **Build** — make small, reversible changes. Keep context compact by delegating independent, read-only exploration only.
7. **Quality gate** — run appropriate review: architecture, security, accessibility, tests, data validation, or operations.
8. **Deliver** — provide the actual artifact, verification evidence, residual risks, and a clear next owner.
9. **Learn** — record reusable lessons in `corporation/decisions/` without storing secrets or personal data.

## Scale rules

- One accountable owner; one delivery plan; one definition of done.
- A swarm is justified only for independent research or clearly separable artifacts. Consolidate into one review before execution.
- Cap routine work at three specialist reviewers. Escalate only when evidence demands it.
- Child explorers are read-only and return summaries; they preserve the main session's context.
- No automated commits, deployments, purchases, credential use, browser logins, or system-wide installs.
