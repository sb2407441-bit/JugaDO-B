@echo off
setlocal
REM OpenCut wrapper - start / stop / status for the open-source CapCut alternative
set "OC_DIR=D:\Resources\opencut-classic"
set "BUN=%USERPROFILE%\.bun\bin\bun.exe"
set "OC_PORT=3005"
set "URL=http://localhost:3005"

if not exist "%BUN%" (
  echo OpenCut requires Bun. Install it with: irm https://bun.sh/install.ps1 ^| iex
  exit /b 1
)

if /i "%~1"=="status" goto :status
if /i "%~1"=="start" goto :start
if /i "%~1"=="stop"  goto :stop
if /i "%~1"=="log"   goto :log
if /i "%~1"=="loge"  goto :loge

echo Usage: opencut.cmd {start ^| stop ^| status ^| log ^| loge}
exit /b 0

:status
netstat -ano | findstr ":%OC_PORT%" | findstr "LISTENING" >nul 2>&1
if errorlevel 1 (
  echo OpenCut is STOPPED.
  exit /b 1
)
echo OpenCut is RUNNING at %URL%
exit /b 0

:start
netstat -ano | findstr ":%OC_PORT%" | findstr "LISTENING" >nul 2>&1
if not errorlevel 1 (
  echo OpenCut is already running at %URL%
  exit /b 0
)
if not exist "%OC_DIR%\apps\web\.env.local" copy /y "%OC_DIR%\apps\web\.env.example" "%OC_DIR%\apps\web\.env.local" >nul
echo Starting OpenCut dev server on port %OC_PORT%...
start "OpenCut dev" /min cmd /c "cd /d %OC_DIR%\apps\web && ""%BUN%" next dev --turbopack --port %OC_PORT% 1>"%OC_DIR%\dev-web.out.log" 2>"%OC_DIR%\dev-web.err.log""
echo Dev server launching in the background. Watch the log with: opencut.cmd log
exit /b 0

:stop
for /f "tokens=5" %%p in ('netstat -ano ^| findstr ":%OC_PORT%" ^| findstr "LISTENING"') do (
  taskkill /PID %%p /F /T >nul 2>&1
)
echo OpenCut stopped.
exit /b 0

:log
if exist "%OC_DIR%\dev-web.out.log" powershell -Command "Get-Content -LiteralPath '%OC_DIR%\dev-web.out.log' -Tail 30"
exit /b 0

:loge
if exist "%OC_DIR%\dev-web.err.log" powershell -Command "Get-Content -LiteralPath '%OC_DIR%\dev-web.err.log' -Tail 30"
exit /b 0
