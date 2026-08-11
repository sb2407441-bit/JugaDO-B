$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$python = Join-Path $root '.venv\Scripts\python.exe'

if (-not (Test-Path $python)) { throw 'OpenWorker .venv is missing.' }
& $python -m pip check
if ($LASTEXITCODE -ne 0) { throw 'Python dependency check failed.' }

& $python -c "from pathlib import Path; from coworker.personas.manifest import load_manifest_file; files=list(Path('personas').rglob('*.md')); [load_manifest_file(f) for f in files]; print(f'validated_personas={len(files)}')"
if ($LASTEXITCODE -ne 0) { throw 'Persona validation failed.' }

$checks = [ordered]@{
    'Agency source' = Test-Path (Join-Path $root 'vendor\agency-agents')
    'gstack source' = Test-Path (Join-Path $root 'vendor\gstack')
    'Context7 source' = Test-Path (Join-Path $root 'vendor\context7')
    'Agent Reach CLI' = Test-Path (Join-Path $root '.venv\Scripts\agent-reach.exe')
}
$checks.GetEnumerator() | ForEach-Object { '{0}: {1}' -f $_.Key, $_.Value }
