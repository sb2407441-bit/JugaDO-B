# COLLABORATION.md — Team Collaboration Patterns & Norms · JugaDO-B / OpenWorker AI OS

Practical patterns for how the team works together. Apply the right pattern to the task; follow the norms every time.

---

## Task Patterns

Choose the pattern that matches the task's shape before assigning work.

### 1. SOLO
**When to use:** Simple, focused tasks with a clear single owner and no dependencies on other personas.

One specialist receives the brief, executes, passes the Delivery Checklist, and returns the artifact. No handoff required.

---

### 2. LEAD + REVIEWER
**When to use:** Standard tasks where a second set of eyes materially reduces risk — code changes, proposals, external communications.

The executor completes the work, then issues a Review Request (see `HANDOFF-PROTOCOL.md`) to the reviewer. The reviewer checks against the relevant quality gate and signs off or returns with specific feedback. The executor owns the artifact throughout.

---

### 3. SERIAL CHAIN
**When to use:** Multi-phase work where each phase depends on the output of the prior phase — e.g. research → design → implementation → documentation.

Each persona completes their phase, passes the Delivery Checklist, and issues a full Handoff Brief to the next persona. No phase starts until the prior phase's output is confirmed sufficient. The Chief of Staff tracks the chain and holds the thread.

---

### 4. PARALLEL RESEARCH SWARM
**When to use:** Discovery and research tasks where multiple independent questions can be explored simultaneously. **Read-only only.**

The Chief of Staff dispatches multiple explorer agents with scoped, non-overlapping research briefs. Each returns a summary. The Chief of Staff consolidates findings before any action is taken. No write operations, no external calls, no config changes during a swarm.

---

### 5. DIRECTOR-LED DELIVERY
**When to use:** Cross-functional product work involving engineering, design, content, and/or security in a single delivery.

The Chief of Staff owns the task end-to-end and coordinates the delivery plan. The gstack Delivery Director owns the build phase. Domain specialists (design, security, content) are consulted via Review Requests or scoped Handoff Briefs. The Chief of Staff integrates outputs and owns the final delivery.

---

## Communication Norms

- **Decisions happen in chat and are recorded.** Any decision that affects scope, architecture, or external systems is logged to `corporation/decisions/` (one markdown file per significant decision, ADR format).
- **In-progress status is tracked via `todo_write`.** Always keep exactly one item `in_progress`. Update as steps complete. Commit task state before ending a session.
- **Blockers are escalated immediately with a proposed resolution.** No silent parking. A blocked task with no status update is a lost task.
- **No re-asking what was already decided.** Check `corporation/decisions/` and the active handoff brief before asking a question that may already be answered.
- **Keep context compact.** Use explorer agents (read-only sub-agents) for broad research. Bring only conclusions into the main thread — not raw dumps.

---

## Escalation Ladder

| Level | From → To | When |
|---|---|---|
| 1 | Specialist → Chief of Staff | Scope exceeds the handoff brief; decision is above the specialist's authority; blocked |
| 2 | Chief of Staff → User | Approval required for a consequential action; task definition needs clarification; two valid plans exist and a choice must be made |
| 3 | Any agent → User (immediate) | Proposed action is irreversible; touches live data or production; involves credentials; involves real money |

Escalation always includes a brief: what was being done, what the issue is, and a proposed resolution where one exists.

---

## Memory and Continuity

How context is preserved across sessions so no work is lost.

| Layer | Mechanism | Scope |
|---|---|---|
| Short-term | OpenWorker's built-in SQLite memory store | Current session and recent history |
| Long-term / knowledge graph | Cognee Memory Curator (load when needed) | Persistent facts, entity relationships |
| Decisions | `corporation/decisions/` — one `.md` per significant decision (ADR format) | Permanent record |
| Task state | `todo_write` — committed before session ends | Active task progress |
| Handoff briefs | `corporation/handoffs/` — one `.md` per cross-session task | Cross-session task continuity |

---

## Anti-Patterns to Avoid

- 🚫 **"I'll just ask all the specialists"** — this is a meeting, not delegation. One owner does the work; specialists are consulted for specific scoped questions.
- 🚫 **Passing work without a brief** — creates context loss and re-work. No brief, no handoff.
- 🚫 **Starting work before open questions are resolved** — assumptions made mid-task are the leading cause of rework and scope drift.
- 🚫 **Reporting completion without a real artifact** — a description of what was done is not a deliverable. Produce the file, code, or report.
- 🚫 **Silently installing dependencies or changing configuration** — always surface and get approval before any system change.
- 🚫 **Parallel execution of write operations** — parallel work is for read-only research only. Writes are always serial and owned.
