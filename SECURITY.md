# Security

This repository is intended to be public-safe. Before publishing or sharing changes:

- Do not commit API keys, access tokens, OAuth secrets, certificates, or private network details.
- Keep credentials in your local environment or a secure secret manager.
- Prefer `.example` configuration files with placeholder values.
- Review generated logs, browser traces, test artifacts, and local state before opening a PR or making the repo public.
- If a secret is ever exposed, revoke it immediately and rotate credentials before continuing.

## Recommended local hygiene

- Use `.env` only locally and ignore it via `.gitignore`.
- Delete any generated logs under `.state`, `.state-test`, `.playwright-mcp`, `playwright-report`, and `test-results` before publishing.
- Do not store private provider config in tracked files.

## What to do before making the repo public

1. Remove or sanitize any file with local endpoints, credentials, or machine-specific setup.
2. Verify `.gitignore` covers local runtime and secret artifacts.
3. Check the Git history for accidentally committed secrets. If needed, rewrite history and rotate affected credentials.
