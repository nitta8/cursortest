# cursortest

**やることリスト** — ボタン操作だけで使えるタスク管理アプリです。

## Windows で使う

PowerShell に **この1行** をコピー＆ペースト:

```powershell
Invoke-WebRequest "https://raw.githubusercontent.com/nitta8/cursortest/main/install.ps1?v=4" -OutFile "$env:TEMP\cursortest-install.ps1"; powershell -NoProfile -ExecutionPolicy Bypass -File "$env:TEMP\cursortest-install.ps1"
```

自動でインストール → デスクトップに「やることリスト」作成 → アプリ起動。

## 2回目以降

デスクトップの **「やることリスト」** をダブルクリック。

## アプリの使い方

1. やることを入力 → **追加する**
2. タスクを選ぶ → **完了にする** または **削除**

## ファイル構成

| ファイル | 説明 |
|---------|------|
| `tasks_app.py` | やることリスト（GUI） |
| `install.ps1` | インストーラー |
