@echo off
echo Installing...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest 'https://raw.githubusercontent.com/nitta8/cursortest/main/install.ps1?v=4' -OutFile ($env:TEMP + '\cursortest-install.ps1')"
powershell -NoProfile -ExecutionPolicy Bypass -File "%TEMP%\cursortest-install.ps1"
pause
