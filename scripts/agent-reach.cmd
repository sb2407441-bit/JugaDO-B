@echo off
setlocal
for %%I in ("%~dp0..") do set "OPENWORKER_ROOT=%%~fI"
set "PATH=%OPENWORKER_ROOT%\.venv\Scripts;%PATH%"
"%OPENWORKER_ROOT%\.venv\Scripts\agent-reach.exe" %*
exit /b %ERRORLEVEL%
