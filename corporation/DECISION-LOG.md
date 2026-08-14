# Decision log

Durable record of decisions, outcomes, and surprises. One entry per piece of work.

Entries are appended, never overwritten. `scripts/self-improve.ps1` reads this file to mine
recurring patterns, so keep the heading shape below.

```markdown
## YYYY-MM-DD · short-slug

**Request:** what was asked.

**Classification:** which departments, and the risk level.

**Decisions:**
1. ...

**Outcome:** what exists now.

**Verification:** how it was proven.

**Follow-ups:** what is still open.
```

## Ground rules

- Never paste credentials, API keys, tokens, or bearer values into an entry. Reference the
  environment variable name instead.
- Never record customer or client identities, briefs, or commercial terms. Describe the work
  in generic terms.
- Never record machine-local absolute paths, LAN addresses, or internal endpoints.
- Log the reversible step you took and the evidence that it worked.

> The pre-publication history of this file was an internal operations journal and was removed
> when the repository was opened to the public.
