# Public-safe repo note

This repository was sanitized for public release.

The original internal notes included private LAN addresses, local service endpoints, and operational configuration details that are not appropriate for a public repository.

For public use:
- Keep credentials in a local secure store or secret manager.
- Never commit `.env`, `.token`, certificate, or key files.
- Prefer example configuration files with placeholder values.
- Delete local runtime logs and browser traces before publishing.

If you self-host services, configure them privately and do not expose internal IPs, control-plane endpoints, or operational setup details in the project repository.
