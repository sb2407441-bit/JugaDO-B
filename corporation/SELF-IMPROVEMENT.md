# Self-Improvement Governance

Owned by the Corporate Chief of Staff. This is how OpenWorker learns from its own work —
measured, approved, and reversible. It mirrors the keep/revert principle of
`recursive-improve`: an improvement sticks only if verified better; it reverts if worse.

## 1. The loop

```
OBSERVE  →  ANALYZE  →  PROPOSE  →  APPROVE  →  APPLY  →  VERIFY / ROLLBACK
```

### Observe
`.\scripts\self-improve.ps1` reads `corporation/DECISION-LOG.md` and `ROUTING.md` and
emits `runtime-state\self-improve-report.md` with:
- recurring signals (visual-QA gaps, placeholder flags, honest-research gaps, risk density)
- routing load by owner (which personas carry the most work)
- a cluster of recent known-risks / open items

### Analyze
The Chief of Staff reads the report against live context. A pattern is actionable only if it
recurred (≥2 entries) or is a single high-cost lesson.

### Propose
Proposals are concrete edits, always stated as: change → expected effect → rollback path.
Example: "Add a no-placeholder check to QA gate 5.3 → prevents client-facing fakes →
revert = delete the checklist line."

### Approve
- Low risk (doc wording, checklist additions): approve in the proposal thread.
- Medium/high risk (routing re-wiring, new tools, workflow changes): explicit user approval.
- Never applied silently. The agent does not self-approve its own proposals.

### Apply
One reversible step at a time. Record the change in `DECISION-LOG.md` with the proposal
reference.

### Verify / Rollback
Before the change is trusted, verify it on the next one or two tasks:
- Better → keep, log evidence.
- No difference / worse → revert, log what the regression taught us.

## 2. What self-improvement covers

- Persona and routing rules (`ROUTING.md`, persona files) proven wrong by outcomes.
- Quality gates (`AGENTS.md` §5) that missed a recurring defect.
- Resource adapters that under- or over-delivered (`RESOURCE-CAPABILITY-MAP.md`).
- Repetitive toil that a script or skill should absorb.

## 3. Scope boundary

"Self-learning" here means improving **memory, prompts, skills, workflows, and process**
based on measured results. It does not mean retraining a foundation model, changing
credentials, or acting without approval. Benchmarks and rollback are mandatory so the agent
cannot permanently learn its own mistakes.

## 4. Heavier adapters (cloned, activation-gated)

Cloned into `D:\Resources\seo\self-improving`, adapter-ready but **not** running:

| Adapter | Role | Activation gate |
|---|---|---|
| `recursive-improve` | trace → analyze → propose → benchmark → keep/revert | explicit approval before pip install or benchmark runs |
| `mem0` | persistent memory layer (lessons, preferences, results) | explicit approval before pip install; optional Supabase |
| `letta-code` / `letta` | stateful agent runtime with self-rewriting skills | explicit approval before npm install / server activation |

Use the native loop first (zero install). Adopt a heavier adapter only when the native loop
demonstrates a concrete need the report cannot cover.

## 5. Success criteria

- Every applied improvement is verifiable: before/after evidence in `DECISION-LOG.md`.
- Recurring signals in `self-improve-report.md` trend downward run over run.
- No change to governance, routing, or tooling happens without an entry in the decision log.
