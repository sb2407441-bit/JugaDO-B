param(
    [string]$HumanAiBaseUrl = "",
    [string]$HumanAiHost = "",
    [string]$Model = "omniroute:oc/nemotron-3-ultra-free"
)

$ErrorActionPreference = "Stop"

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

if (-not (Test-Path $HermesHome)) {
    throw "Hermes home does not exist: $HermesHome"
}
if (-not (Get-Command hermes -ErrorAction SilentlyContinue)) {
    throw "hermes is not available in this PowerShell session"
}

New-Item -ItemType Directory -Path $BackupPath -Force | Out-Null
if (Test-Path $ConfigPath) {
    Copy-Item -LiteralPath $ConfigPath -Destination $BackupPath -Force
}
if (Test-Path $EnvPath) {
    Copy-Item -LiteralPath $EnvPath -Destination $BackupPath -Force
}

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
    & hermes config set model.provider custom
    if ($LASTEXITCODE -ne 0) { throw "config set model.provider failed" }
    & hermes config set model.default $Model
    if ($LASTEXITCODE -ne 0) { throw "config set model.default failed" }
    & hermes config set model.base_url "$HumanAiBaseUrl/v1"
    if ($LASTEXITCODE -ne 0) { throw "config set model.base_url failed" }
    & hermes config set model.api_key '${HUMAN_AI_API_TOKEN}'
    if ($LASTEXITCODE -ne 0) { throw "config set model.api_key failed" }
} catch {
    throw "Hermes model configuration failed; backup is at $BackupPath. $($_.Exception.Message)"
}

Write-Host "Restarting Hermes gateway..."
& hermes gateway stop
Start-Sleep -Seconds 2
& hermes gateway start
Start-Sleep -Seconds 3
& hermes gateway status

Write-Host "Bridge restore complete. Backup: $BackupPath"
Write-Host "Human AI: $HumanAiBaseUrl"