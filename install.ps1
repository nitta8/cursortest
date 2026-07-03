# Windows one-click setup for cursortest (no Git required).
# Usage: irm https://raw.githubusercontent.com/nitta8/cursortest/main/install.ps1 | iex

$ErrorActionPreference = "Stop"

$RepoZipUrl = "https://github.com/nitta8/cursortest/archive/refs/heads/main.zip"
$InstallDir = Join-Path $env:USERPROFILE "cursortest"
$BinDir = Join-Path $env:USERPROFILE "bin"
$ZipPath = Join-Path $env:TEMP "cursortest-main.zip"
$ExtractRoot = Join-Path $env:TEMP "cursortest-extract"
$LauncherPath = Join-Path $BinDir "tasks.cmd"

function Write-Step($Message) {
    Write-Host "=> $Message" -ForegroundColor Cyan
}

function Find-Python {
    $python = Get-Command python -ErrorAction SilentlyContinue
    if ($python) {
        return @("python", $python.Source)
    }

    $py = Get-Command py -ErrorAction SilentlyContinue
    if ($py) {
        return @("py -3", $py.Source)
    }

    return $null
}

function Add-ToUserPath([string]$Directory) {
    $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
    $parts = $userPath -split ";" | Where-Object { $_ -ne "" }

    if ($parts -contains $Directory) {
        return
    }

    $newPath = if ($userPath) { "$userPath;$Directory" } else { $Directory }
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    $env:Path = "$env:Path;$Directory"
}

Write-Step "Checking Python..."
$pythonInfo = Find-Python
if (-not $pythonInfo) {
    Write-Host ""
    Write-Host "Python is not installed." -ForegroundColor Red
    Write-Host "1. Open https://www.python.org/downloads/"
    Write-Host "2. Install Python and check 'Add python.exe to PATH'"
    Write-Host "3. Close PowerShell, open it again, and rerun this script."
    exit 1
}

$pythonCmd = $pythonInfo[0]
Write-Host "   Found: $($pythonInfo[1])"

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

Write-Step "Creating launcher in $BinDir ..."
New-Item -ItemType Directory -Path $BinDir -Force | Out-Null
@(
    "@echo off",
    "cd /d `"$InstallDir`"",
    "python tasks.py %*"
) | Set-Content -Path $LauncherPath -Encoding ASCII

Write-Step "Adding launcher folder to PATH..."
Add-ToUserPath $BinDir

Write-Step "Running a quick test..."
Push-Location $InstallDir
if ($pythonCmd -eq "py -3") {
    & py -3 tasks.py add "セットアップ完了"
    & py -3 tasks.py list
} else {
    & python tasks.py add "セットアップ完了"
    & python tasks.py list
}
Pop-Location

Write-Host ""
Write-Host "Done!" -ForegroundColor Green
Write-Host ""
Write-Host "Install folder: $InstallDir"
Write-Host "Launcher:       $LauncherPath"
Write-Host ""
Write-Host "Important: close PowerShell and open it again, then run:"
Write-Host "  tasks add `"牛乳を買う`""
Write-Host "  tasks list"
Write-Host ""
Write-Host "If PATH is not updated yet, use either:"
Write-Host "  $LauncherPath add `"牛乳を買う`""
Write-Host "  cd $InstallDir"
Write-Host "  python tasks.py list"
