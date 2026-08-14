# HANDOFF-PROTOCOL.md — Inter-Persona Handoff Standard · JugaDO-B / OpenWorker AI OS

---

## Why Handoff Briefs Exist

Context loss is the primary cause of re-work, missed constraints, and duplicated effort. A handoff brief ensures the receiving persona has everything it needs to start — decisions already made, approaches already tried, hard limits, and the exact deliverable expected. Without a brief, the receiver must reconstruct context from scratch or make assumptions that break the task.

**A brief is not a courtesy. It is a prerequisite.**

---

## Standard Handoff Brief

Use this template every time work passes from one persona to another.

```markdown
## Handoff Brief — [short task title]

**From:** [sending persona id]
**To:** [receiving persona id]
**Date:** [date]
**Priority:** [routine | standard | urgent]

### Goal
[One sentence: what the receiving persona must produce]

### Context
[What the sending persona knows that the receiver needs: decisions made, constraints discovered, failed approaches]

### Inputs
[Files, data, API responses, research summaries, links — everything the receiver needs to start]

### Constraints
[Hard limits: budget, timeline, tech stack, must-not-touch]

### Expected Output
[Exact deliverable: file path + format, or artifact description]

### Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

### Approval Gate
[What requires user approval before the receiver acts: installs, writes, external calls]

### Open Questions
[Unresolved decisions the receiver must surface before proceeding]
```

---

## Handoff Rules

1. **Never hand off without a brief.** Verbal summaries cause context loss. If there is no brief, there is no handoff.
2. **The sender remains accountable until the receiver confirms the brief is sufficient.** Confirmation is explicit, not assumed.
3. **Open questions must be surfaced before work starts.** If the receiver discovers a gap mid-task, they stop and escalate — they do not guess.
4. **A handoff to a specialist does not transfer ownership.** The Chief of Staff retains the thread. The specialist executes a scoped task and returns the output.
5. **Rejected handoffs are sent back.** If a brief is insufficient, the receiver returns it to the sender with the specific gaps noted. The sender fills the gaps before re-sending.
6. **Parallel handoffs (swarms) are only valid for independent read-only exploration.** Never use parallel handoffs for write operations. See `COLLABORATION.md` for the Parallel Research Swarm pattern.

---

## Review Request Format

Use this simpler format when asking a specialist to review an artifact — not to execute a full task.

```markdown
## Review Request — [short title]

**Reviewer:** [persona id]
**Artifact:** [file path or description]
**Question:** [specific question or gate to check]
**Decision needed by:** [urgency]
```

---

## Escalation Path

If a specialist is blocked during execution:

1. **Stop work immediately.** Do not guess, do not proceed past the blocker.
2. **Write an escalation brief** to the Chief of Staff with:
   - What was being done
   - What the blocker is
   - What information or decision is needed to unblock
   - A proposed resolution (if one exists)
3. **Do not silently abandon the task.** A task with no status update is indistinguishable from a lost task.

The Chief of Staff resolves the blocker or escalates to the user if a consequential decision is required.

---

## Handoff Storage

Briefs for tasks that span sessions are saved to `corporation/handoffs/`. Create the directory on first use. File naming: `YYYY-MM-DD-[short-task-slug].md`.
