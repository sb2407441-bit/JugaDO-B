# Agency Personas

`vendor/agency-agents` is the vendored source of truth. The PowerShell installer converts its
prompt-only Agency Agents into OpenWorker persona manifests without bringing in executable code.
Each generated persona receives only OpenWorker's vetted capability catalog.

Build the recommended AI-employee team:

Preview the focused roster (no server changes):

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install-agency-personas.ps1
```

After reviewing the requested capabilities, enable the team:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install-agency-personas.ps1 -Approve
```

To generate, install, and enable the entire 270-role catalog, run
`powershell -ExecutionPolicy Bypass -File .\scripts\install-agency-personas.ps1 -All -Approve`.
It uses the same snapshot and consent mechanism as the OpenWorker desktop app.
