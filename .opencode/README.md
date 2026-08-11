# Agency Agents for OpenCode

The full Agency Agents source lives in `vendor/agency-agents`. Its 270 OpenCode-ready
definitions are intentionally not all copied into `.opencode/agents`: OpenCode has a practical
agent-registration limit, and an enormous picker makes the AI employee hard to operate.

Install a focused project roster by running the following from this repository after choosing the
roles you want:

```powershell
New-Item -ItemType Directory -Force .opencode\agents | Out-Null
Copy-Item vendor\agency-agents\integrations\opencode\agents\chief-of-staff.md .opencode\agents\
Copy-Item vendor\agency-agents\integrations\opencode\agents\operations-manager.md .opencode\agents\
Copy-Item vendor\agency-agents\integrations\opencode\agents\senior-developer.md .opencode\agents\
```

Use each role on demand in OpenCode, for example `@chief-of-staff plan the work` or
`@security-architect review the design`.
