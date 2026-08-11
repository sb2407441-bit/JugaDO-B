param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Arguments
)

$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$cli = Join-Path $root '.venv\Scripts\agent-reach.exe'
if (-not (Test-Path -LiteralPath $cli)) {
    throw "Agent Reach is not installed in this workspace. Run .\.venv\Scripts\python.exe -m pip install -e D:\Resources\agent-reach first."
}

# Let Agent Reach find the tools installed beside it (yt-dlp, etc.) without
# relying on a machine-wide PATH modification.
$env:Path = "$(Split-Path $cli -Parent);$env:Path"
& $cli @Arguments
exit $LASTEXITCODE
