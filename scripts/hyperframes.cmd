@echo off
setlocal
where npx >nul 2>&1
if errorlevel 1 (
  echo HyperFrames requires Node.js 22+ and npx. Install the approved workspace runtime first.
  exit /b 1
)
npx hyperframes %*
exit /b %ERRORLEVEL%
