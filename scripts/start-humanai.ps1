# Human AI OS — one-command start (server + GUI)
# Usage:  powershell -ExecutionPolicy Bypass -File .\scripts\start-humanai.ps1

$ErrorActionPreference = "Stop"
$Root = "D:\OPENWORKER"
$State = Join-Path $Root "runtime-state"
New-Item -ItemType Directory -Force -Path $State | Out-Null

# 1. Start the agent server (port 8765) if not already running.
$serverRunning = Get-NetTCPConnection -LocalPort 8765 -State Listen -ErrorAction SilentlyContinue
if ($serverRunning) {
    Write-Host "[server] already listening on 8765"
} else {
    Write-Host "[server] starting humanai-server on 8765 ..."
    Start-Process -FilePath (Join-Path $Root ".venv\Scripts\humanai-server.exe") `
        -ArgumentList "--cwd", $Root, "--port", "8765" `
        -RedirectStandardOutput (Join-Path $State "server-8765.out.log") `
        -RedirectStandardError  (Join-Path $State "server-8765.err.log") `
        -WindowStyle Hidden
    Start-Sleep -Seconds 6
    Write-Host "[server] started (logs in runtime-state\server-8765.*.log)"
}

# 2. Start the Vite GUI (port 5175) if not already running.
$guiRunning = Get-NetTCPConnection -LocalPort 5175 -State Listen -ErrorAction SilentlyContinue
if ($guiRunning) {
    Write-Host "[gui] already listening on 5175"
} else {
    Write-Host "[gui] starting vite dev server on 5175 ..."
    $guiDir = Join-Path $Root "surfaces\gui"
    Start-Process -FilePath "C:\Program Files\nodejs\node.exe" `
        -ArgumentList "node_modules\vite\bin\vite.js", "--port", "5175", "--strictPort" `
        -WorkingDirectory $guiDir `
        -RedirectStandardOutput (Join-Path $State "vite.out.log") `
        -RedirectStandardError  (Join-Path $State "vite.err.log") `
        -WindowStyle Hidden
    Start-Sleep -Seconds 5
    Write-Host "[gui] started (logs in runtime-state\vite.*.log)"
}

Write-Host ""
Write-Host "Human AI OS is UP."
Write-Host "  Server API : http://127.0.0.1:8765  (token in %APPDATA%\coworker\sidecar-8765.token)"
Write-Host "  GUI        : http://localhost:5175"
Write-Host ""
Write-Host "Open the GUI in your browser, pick a persona (Personas), and start a task."
