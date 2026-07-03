# cursortest

**やることリスト** — ボタン操作だけで使えるタスク管理アプリです。

## Windows で使う

PowerShell に **この1行** をコピー＆ペースト:

```powershell
$ErrorActionPreference='Stop';$d=Join-Path $env:USERPROFILE 'cursortest';$z=Join-Path $env:TEMP ('c'+[guid]::NewGuid().ToString('N')+'.zip');$x=Join-Path $env:TEMP ('x'+[guid]::NewGuid().ToString('N'));Invoke-WebRequest 'https://github.com/nitta8/cursortest/archive/refs/heads/main.zip' -OutFile $z -UseBasicParsing;Expand-Archive $z $x -Force;if(Test-Path $d){Remove-Item $d -Recurse -Force};Move-Item (Join-Path $x 'cursortest-main') $d;$py=(Get-Command python).Source;$pw=$py -replace 'python.exe','pythonw.exe';if(-not(Test-Path $pw)){$pw=$py};$desk=[Environment]::GetFolderPath('Desktop');$cmd=Join-Path $desk 'TaskList.cmd';$lnk=Join-Path $desk 'TaskList.lnk';$app=Join-Path $d 'tasks_app.py';$bat=(@('@echo off',"cd /d `"$d`"","start `"`" `"$pw`" `"$app`"") -join [Environment]::NewLine);Set-Content $cmd $bat -Encoding ASCII;$s=(New-Object -ComObject WScript.Shell).CreateShortcut($lnk);$s.TargetPath=$cmd;$s.WorkingDirectory=$d;$s.Save();Start-Process $cmd;Write-Host 'Done! Double-click TaskList on Desktop.' -ForegroundColor Green
```

## 2回目以降

デスクトップの **TaskList** をダブルクリック。

## アプリの使い方

1. やることを入力 → **追加する**
2. タスクを選ぶ → **完了にする** または **削除**
