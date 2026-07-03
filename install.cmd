@echo off
chcp 65001 >nul
title やることリスト インストール
echo.
echo やることリストをセットアップしています...
echo 少し待ってください。
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$ErrorActionPreference='Stop';" ^
  "$InstallDir=Join-Path $env:USERPROFILE 'cursortest';" ^
  "$ZipPath=Join-Path $env:TEMP 'cursortest.zip';" ^
  "$ExtractRoot=Join-Path $env:TEMP 'cursortest-extract';" ^
  "$Desktop=[Environment]::GetFolderPath('Desktop');" ^
  "$LauncherPath=Join-Path $Desktop 'やることリスト.cmd';" ^
  "$ShortcutPath=Join-Path $Desktop 'やることリスト.lnk';" ^
  "if (-not (Get-Command python -ErrorAction SilentlyContinue)) { Write-Host 'Python が見つかりません。https://www.python.org/downloads/ からインストールしてください。' -ForegroundColor Red; exit 1 };" ^
  "Invoke-WebRequest 'https://github.com/nitta8/cursortest/archive/refs/heads/main.zip' -OutFile $ZipPath -UseBasicParsing;" ^
  "if (Test-Path $ExtractRoot) { Remove-Item $ExtractRoot -Recurse -Force };" ^
  "New-Item -ItemType Directory -Path $ExtractRoot -Force | Out-Null;" ^
  "Expand-Archive -Path $ZipPath -DestinationPath $ExtractRoot -Force;" ^
  "if (Test-Path $InstallDir) { Remove-Item $InstallDir -Recurse -Force };" ^
  "Move-Item (Join-Path $ExtractRoot 'cursortest-main') $InstallDir;" ^
  "$AppPath=Join-Path $InstallDir 'tasks_app.py';" ^
  "$PythonPath=(Get-Command python).Source;" ^
  "$PythonwPath=$PythonPath -replace 'python.exe','pythonw.exe';" ^
  "if (-not (Test-Path $PythonwPath)) { $PythonwPath=$PythonPath };" ^
  "$Bat=@('@echo off', \"cd /d `\"$InstallDir`\"\", \"start `\"`\" `\"$PythonwPath`\" `\"$AppPath`\"\") -join [Environment]::NewLine;" ^
  "Set-Content -Path $LauncherPath -Value $Bat -Encoding ASCII;" ^
  "$Shell=New-Object -ComObject WScript.Shell;" ^
  "$Shortcut=$Shell.CreateShortcut($ShortcutPath);" ^
  "$Shortcut.TargetPath=$LauncherPath;" ^
  "$Shortcut.WorkingDirectory=$InstallDir;" ^
  "$Shortcut.Description='やることリスト';" ^
  "$Shortcut.Save();" ^
  "Start-Process $LauncherPath;" ^
  "Write-Host '';" ^
  "Write-Host '完了しました！' -ForegroundColor Green;" ^
  "Write-Host 'デスクトップの「やることリスト」をダブルクリックして使えます。';"

if errorlevel 1 (
    echo.
    echo インストールに失敗しました。
    pause
    exit /b 1
)

echo.
pause
