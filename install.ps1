# Windows setup for cursortest (ASCII only).
# Version: 6

$ErrorActionPreference = "Stop"

$RepoZipUrl = "https://github.com/nitta8/cursortest/archive/refs/heads/main.zip"
$InstallDir = Join-Path $env:USERPROFILE "cursortest"
$ZipPath = Join-Path $env:TEMP "cursortest-main.zip"
$ExtractRoot = Join-Path $env:TEMP "cursortest-extract"
$Desktop = [Environment]::GetFolderPath("Desktop")
$ShortcutPath = Join-Path $Desktop "TaskList.lnk"
$LauncherPath = Join-Path $Desktop "TaskList.cmd"

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
    Write-Host "Install from https://www.python.org/downloads/"
    exit 1
}

Write-Host "   Found: $pythonPath"

Write-Step "Downloading app..."
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

if ($pythonwPath -eq "pyw") {
    $launchLine = "start `"`" pyw -3 `"$appPath`""
} else {
    $launchLine = "start `"`" `"$pythonwPath`" `"$appPath`""
}

$batLines = @(
    "@echo off",
    "cd /d `"$InstallDir`"",
    $launchLine
)
Set-Content -Path $LauncherPath -Value ($batLines -join [Environment]::NewLine) -Encoding ASCII

$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($ShortcutPath)
$shortcut.TargetPath = $LauncherPath
$shortcut.WorkingDirectory = $InstallDir
$shortcut.WindowStyle = 1
$shortcut.Description = "Task List App"
$shortcut.Save()

Write-Step "Launching app..."
Start-Process $LauncherPath

Write-Host ""
Write-Host "Done!" -ForegroundColor Green
Write-Host "Double-click TaskList on your Desktop next time."
