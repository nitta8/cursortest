@echo off
chcp 65001 >nul
echo Installing task app...
powershell -NoProfile -ExecutionPolicy Bypass -Command "irm 'https://raw.githubusercontent.com/nitta8/cursortest/main/install.ps1?v=3' | iex"
if errorlevel 1 (
    echo.
    echo Install failed.
    pause
)
