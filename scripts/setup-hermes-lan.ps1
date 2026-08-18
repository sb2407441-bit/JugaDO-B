param(
    [string]$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")),
    [string]$HumanAiBaseUrl = "",
    [string]$HumanAiHost = "",
    [string]$Model = "omniroute:oc/nemotron-3-ultra-free"
)

$ErrorActionPreference = "Stop"

function Invoke-Checked {
    param(
        [string]$Command,
        [string[]]$Arguments
    )
    & $Command @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "$Command $($Arguments -join ' ') failed with exit code $LASTEXITCODE"
    }
}

$RepoRoot = (Resolve-Path $RepoRoot).Path
$HermesHome = if ($env:HERMES_HOME) {
    $env:HERMES_HOME
} else {
    Join-Path $HOME ".hermes"
}
$ConfigPath = Join-Path $HermesHome "config.yaml"
$EnvPath = Join-Path $HermesHome ".env"
$BackupRoot = Join-Path $HermesHome "backups\human-ai-lan"
$Stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$BackupPath = Join-Path $BackupRoot $Stamp

if (-not (Test-Path (Join-Path $RepoRoot ".git"))) {
    throw "RepoRoot is not a Git checkout: $RepoRoot"
}
if (-not (Test-Path $HermesHome)) {
    throw "Hermes home does not exist: $HermesHome"
}
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw "git is not available in this PowerShell session"
}
if (-not (Get-Command hermes -ErrorAction SilentlyContinue)) {
    throw "hermes is not available in this PowerShell session"
}
if (-not (Get-Command bash -ErrorAction SilentlyContinue)) {
    throw "bash is required to regenerate/install the Hermes plugin"
}

New-Item -ItemType Directory -Path $BackupPath -Force | Out-Null
foreach ($path in @($ConfigPath, (Join-Path $HermesHome "gateway-config.yaml"))) {
    if (Test-Path $path) {
        Copy-Item -LiteralPath $path -Destination $BackupPath -Force
    }
}

# Resolve the Human AI server address. Priority:
#   1. Explicit -HumanAiBaseUrl
#   2. Explicit -HumanAiHost (port 8765 assumed)
#   3. Existing config.yaml model.base_url host if reachable
#   4. DNS hostname resolution
#   5. LAN scan for a server listening on TCP 8765
if (-not $HumanAiBaseUrl) {
    $resolved = $HumanAiHost
    if (-not $resolved -and (Test-Path $ConfigPath)) {
        $existing = Select-String -LiteralPath $ConfigPath -Pattern '^\s*base_url:\s*http://([^/:]+)' | Select-Object -Last 1
        if ($existing -and $existing.Matches[0].Groups[1].Value) {
            $candidate = $existing.Matches[0].Groups[1].Value
            $tcp = Test-NetConnection -ComputerName $candidate -Port 8765 -WarningAction SilentlyContinue -InformationLevel Quiet
            if ($tcp) { $resolved = $candidate }
        }
    }
    if (-not $resolved) {
        foreach ($name in @("human-ai.local", "human-ai", "openworker.local", "humanai.local", "humanai")) {
            try {
                $dns = Resolve-DnsName $name -ErrorAction Stop | Where-Object { $_.IPAddress }
                if ($dns) {
                    $candidate = ($dns | Select-Object -First 1).IPAddress
                    $tcp = Test-NetConnection -ComputerName $candidate -Port 8765 -WarningAction SilentlyContinue -InformationLevel Quiet
                    if ($tcp) { $resolved = $candidate; break }
                }
            } catch { }
        }
    }
    if (-not $resolved) {
        Write-Host "Scanning local subnet for Human AI server (TCP 8765)..."
        $localIp = (Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue |
            Where-Object { $_.IPAddress -notlike "127.*" -and $_.IPAddress -notlike "169.254.*" -and $_.PrefixOrigin -eq "Dhcp" } |
            Select-Object -First 1).IPAddress
        if (-not $localIp) {
            throw "Could not determine local IPv4 address to scan for Human AI. Pass -HumanAiBaseUrl explicitly."
        }
        $subnet = ($localIp -split '\.')[0..2] -join '.'
        foreach ($i in 1..254) {
            $ip = "$subnet.$i"
            if ($ip -eq $localIp) { continue }
            $tcp = Test-NetConnection -ComputerName $ip -Port 8765 -WarningAction SilentlyContinue -InformationLevel Quiet
            if ($tcp) { $resolved = $ip; break }
        }
    }
    if (-not $resolved) {
        throw "Could not locate the Human AI server on this network. Pass -HumanAiBaseUrl (or -HumanAiHost) explicitly."
    }
    $HumanAiBaseUrl = "http://$resolved:8765"
    Write-Host "Auto-detected Human AI at $HumanAiBaseUrl"
}

Write-Host "Syncing JugaDO-B..."
Invoke-Checked "git" @("-C", $RepoRoot, "pull", "--ff-only")

$ConvertScript = Join-Path $RepoRoot "vendor\agency-agents\scripts\convert.sh"
$InstallScript = Join-Path $RepoRoot "vendor\agency-agents\scripts\install.sh"
if (-not (Test-Path $ConvertScript) -or -not (Test-Path $InstallScript)) {
    throw "Agency Agents Hermes scripts are missing from $RepoRoot"
}

Write-Host "Regenerating and installing the 270-agent Hermes plugin..."
Push-Location (Split-Path $ConvertScript -Parent)
try {
    Invoke-Checked "bash" @("convert.sh", "--tool", "hermes")
    Invoke-Checked "bash" @("install.sh", "--tool", "hermes")
} finally {
    Pop-Location
}

Write-Host "Configuring Human AI as Hermes' primary model..."
[Environment]::SetEnvironmentVariable("HUMAN_AI_BASE_URL", $HumanAiBaseUrl, "User")
$env:HUMAN_AI_BASE_URL = $HumanAiBaseUrl
if (Test-Path $EnvPath) {
    $envLines = Get-Content -LiteralPath $EnvPath
    $envLines = $envLines | ForEach-Object {
        if ($_ -match '^\s*HUMAN_AI_BASE_URL\s*=') { "HUMAN_AI_BASE_URL=$HumanAiBaseUrl" } else { $_ }
    }
    if ($envLines -notmatch 'HUMAN_AI_BASE_URL=') { $envLines += "HUMAN_AI_BASE_URL=$HumanAiBaseUrl" }
    Set-Content -LiteralPath $EnvPath -Value $envLines -Encoding UTF8
    Write-Host "Updated .env HUMAN_AI_BASE_URL -> $HumanAiBaseUrl"
}

try {
    Invoke-Checked "hermes" @("config", "set", "model.provider", "custom")
    Invoke-Checked "hermes" @("config", "set", "model.default", $Model)
    Invoke-Checked "hermes" @("config", "set", "model.base_url", "$HumanAiBaseUrl/v1")
    Invoke-Checked "hermes" @("config", "set", "model.api_key", '${HUMAN_AI_API_TOKEN}')
} catch {
    throw "Hermes model configuration failed; backup is at $BackupPath. $($_.Exception.Message)"
}

Write-Host "Removing WhatsApp debounce latency..."
& hermes config set gateway.platforms.whatsapp.extra.text_batch_delay_seconds 0
$BatchExit = $LASTEXITCODE
& hermes config set gateway.platforms.whatsapp.extra.text_batch_split_delay_seconds 0
if ($LASTEXITCODE -ne 0 -or $BatchExit -ne 0) {
    Write-Warning "WhatsApp batch settings could not be written automatically. Keep the backup at $BackupPath and inspect gateway.platforms shape."
}

Write-Host "Restarting Hermes gateway..."
& hermes gateway stop
Start-Sleep -Seconds 2
Invoke-Checked "hermes" @("gateway", "start")
& hermes gateway status

$Token = $env:HUMAN_AI_API_TOKEN
if (-not $Token -and (Test-Path $EnvPath)) {
    $tokenLine = Get-Content -LiteralPath $EnvPath | Where-Object { $_ -match '^\s*HUMAN_AI_API_TOKEN\s*=' }
    if ($tokenLine) {
        $Token = ($tokenLine -split "=", 2)[1].Trim().Trim('"').Trim("'")
    }
}
if (-not $Token) {
    Write-Warning "HUMAN_AI_API_TOKEN was not found in the process or Hermes .env; skipping remote health checks."
    exit 0
}

$Headers = @{ Authorization = "Bearer $Token" }
$Health = Invoke-RestMethod -Uri "$HumanAiBaseUrl/v1/health" -Headers $Headers
$Models = Invoke-RestMethod -Uri "$HumanAiBaseUrl/v1/models" -Headers $Headers
$TargetPresent = [bool]($Models.data | Where-Object { $_.id -eq $Model })
if ($Health.status -ne "ok" -or -not $TargetPresent) {
    throw "Human AI health/model check failed; backup is at $BackupPath"
}

Write-Host "Setup complete. Context was preserved."
Write-Host "Hermes home: $HermesHome"
Write-Host "Backup: $BackupPath"
Write-Host "Model: $Model"
Write-Host "Human AI: $HumanAiBaseUrl"
