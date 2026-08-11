$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$catalog = Get-Content (Join-Path $root 'corporation\RESOURCE_CATALOG.json') -Raw | ConvertFrom-Json
foreach ($resource in $catalog.resources) {
    $exists = Test-Path -LiteralPath $resource.path
    '{0}: {1} [{2}]' -f $resource.id, $(if($exists){'present'}else{'missing'}), $resource.status
}
Write-Output ''
Write-Output 'Runtime probes:'
'Node/npx: ' + [bool](Get-Command npx -ErrorAction SilentlyContinue)
'Bun: ' + [bool](Get-Command bun -ErrorAction SilentlyContinue)
'FFmpeg: ' + [bool](Get-Command ffmpeg -ErrorAction SilentlyContinue)
'Agent Reach CLI: ' + (Test-Path (Join-Path $root '.venv\Scripts\agent-reach.exe'))
