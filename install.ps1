# Windows one-click setup for cursortest (no Git required).
# Usage: irm https://raw.githubusercontent.com/nitta8/cursortest/main/install.ps1 | iex

$ErrorActionPreference = "Stop"

$RepoZipUrl = "https://github.com/nitta8/cursortest/archive/refs/heads/main.zip"
$InstallDir = Join-Path $env:USERPROFILE "cursortest"
$ZipPath = Join-Path $env:TEMP "cursortest-main.zip"
$ExtractRoot = Join-Path $env:TEMP "cursortest-extract"
$Desktop = [Environment]::GetFolderPath("Desktop")
$ShortcutPath = Join-Path $Desktop "やることリスト.lnk"
$LauncherPath = Join-Path $Desktop "やることリスト.cmd"

function Write-Step($Message) {
    Write-Host "=> $Message" -ForegroundColor Cyan
}

function Find-Python {
    $python = Get-Command python -ErrorAction SilentlyContinue
    if ($python) {
        return $python.Source
    }

    $py = Get-Command py -ErrorAction SilentlyContinue
    if ($py) {
        return "py"
    }

    return $null
}

function Find-PythonW([string]$PythonPath) {
    if ($PythonPath -eq "py") {
        return "pyw"
    }

    $pythonw = $PythonPath -replace "python.exe", "pythonw.exe"
    if (Test-Path $pythonw) {
        return $pythonw
    }

    return $PythonPath
}

Write-Step "Checking Python..."
$pythonPath = Find-Python
if (-not $pythonPath) {
    Write-Host ""
    Write-Host "Python is not installed." -ForegroundColor Red
    Write-Host "1. Open https://www.python.org/downloads/"
    Write-Host "2. Install Python and check 'Add python.exe to PATH'"
    Write-Host "3. Close PowerShell, open it again, and rerun this script."
    exit 1
}

Write-Host "   Found: $pythonPath"

Write-Step "Downloading cursortest..."
if (Test-Path $ExtractRoot) {
    Remove-Item $ExtractRoot -Recurse -Force
}
New-Item -ItemType Directory -Path $ExtractRoot -Force | Out-Null
Invoke-WebRequest -Uri $RepoZipUrl -OutFile $ZipPath -UseBasicParsing

Write-Step "Installing to $InstallDir ..."
if (Test-Path $InstallDir) {
    Remove-Item $InstallDir -Recurse -Force
}
Expand-Archive -Path $ZipPath -DestinationPath $ExtractRoot -Force
Move-Item (Join-Path $ExtractRoot "cursortest-main") $InstallDir

Write-Step "Creating desktop shortcut..."
$pythonwPath = Find-PythonW $pythonPath
$appPath = Join-Path $InstallDir "tasks_app.py"

$launcherLines = @(
    "@echo off",
    "cd /d `"$InstallDir`""
)
if ($pythonwPath -eq "pyw") {
    $launcherLines += "start `"`" pyw -3 `"$appPath`""
} else {
    $launcherLines += "start `"`" `"$pythonwPath`" `"$appPath`""
}
$launcherLines | Set-Content -Path $LauncherPath -Encoding ASCII

$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($ShortcutPath)
$shortcut.TargetPath = $LauncherPath
$shortcut.WorkingDirectory = $InstallDir
$shortcut.WindowStyle = 1
$shortcut.Description = "やることリスト"
$shortcut.Save()

Write-Step "Launching app..."
Start-Process $LauncherPath

Write-Host ""
Write-Host "Done!" -ForegroundColor Green
Write-Host ""
Write-Host "Desktop shortcut: $ShortcutPath"
Write-Host "Install folder:   $InstallDir"
Write-Host ""
Write-Host "Next time, double-click 'やることリスト' on your Desktop."
