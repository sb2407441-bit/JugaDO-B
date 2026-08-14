# QUALITY-GATES.md — Per-Task-Type Quality Checklists · JugaDO-B / OpenWorker AI OS

A deliverable is not done until its gate is passed. Apply the gate that matches the task type. Apply the Delivery Checklist to every task regardless of type.

---

## Code Gate

**Applies to:** software delivery, refactors, new features, bug fixes

- [ ] Acceptance criteria from the handoff brief are met
- [ ] No new lint errors or type errors introduced
- [ ] Tests cover the change (unit and/or integration as appropriate)
- [ ] No hardcoded secrets, credentials, or environment-specific values
- [ ] Diff is minimal and focused — no unrelated changes bundled in
- [ ] Breaking changes are documented and a migration path is provided
- [ ] **Reviewer:** `code-reviewer` persona sign-off required on changes > 200 lines

---

## Research Gate

**Applies to:** market research, technical research, competitive analysis

- [ ] Sources cited with URLs and retrieval dates
- [ ] Claims verified from at least two independent sources
- [ ] Contradictory evidence noted, not suppressed
- [ ] Recency confirmed — no stale data presented as current
- [ ] Bias disclosure: note if sources have a commercial interest in the claim
- [ ] Summary clearly distinguishes facts from inferences

---

## Content Gate

**Applies to:** reports, documentation, communications, proposals

- [ ] **Accurate:** all claims verified or explicitly marked as estimates
- [ ] **Clear:** no jargon without definition; readable at the target audience level
- [ ] **Complete:** all sections specified in the brief are addressed
- [ ] **Consistent:** terminology, formatting, and tone are uniform throughout
- [ ] **Proofread:** no spelling or grammar errors
- [ ] **Approved:** any external communication requires explicit user approval before sending

---

## Security Gate

**Applies to:** code touching auth, data handling, or infrastructure; security tests

- [ ] Written target authorization on file (mandatory for penetration tests)
- [ ] No secrets in code, logs, or outputs
- [ ] Threat model reviewed for the change
- [ ] OWASP Top 10 checked for web-facing changes
- [ ] Findings triaged: all critical and high items addressed before ship
- [ ] **Security architect sign-off required** for auth changes, cryptography changes, or production infrastructure changes

---

## Data Gate

**Applies to:** data pipelines, analytics, ML training data, reports containing numbers

- [ ] Source schema validated — no assumed columns or types
- [ ] Null handling and edge cases documented
- [ ] No PII retained beyond the scope of the task
- [ ] Outputs spot-checked against source data
- [ ] Methodology documented: all transformations, filters, and aggregations are traceable

---

## Configuration Gate

**Applies to:** env files, MCP server setup, connector config, infrastructure changes

- [ ] All credentials stored in the secret store — not in files
- [ ] Configuration validated in a dry-run before applying
- [ ] Rollback procedure documented before changes are applied
- [ ] No system-wide installs without explicit user approval
- [ ] Changes are scoped to the workspace environment only

---

## Delivery Checklist

**Applies to every task, regardless of type.**

- [ ] Real artifact delivered (file, report, code) — not a description of what to do
- [ ] Artifact location stated explicitly (full path or URL)
- [ ] Verification evidence attached (test output, diff, screenshot, log excerpt)
- [ ] Known limits and residual risks stated
- [ ] Next owner or next action named explicitly
