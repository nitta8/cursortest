# cursortest

**やることリスト** — ボタン操作だけで使えるタスク管理アプリです。

## Windows で使う（いちばんかんたん）

### 方法A: コマンドプロンプト（おすすめ）

```cmd
curl -L -o %TEMP%\install.cmd https://raw.githubusercontent.com/nitta8/cursortest/main/install.cmd && %TEMP%\install.cmd
```

### 方法B: PowerShell

```powershell
Invoke-WebRequest "https://raw.githubusercontent.com/nitta8/cursortest/main/install.ps1?v=3" -OutFile "$env:TEMP\install.ps1"; powershell -NoProfile -ExecutionPolicy Bypass -File "$env:TEMP\install.ps1"
```

> PowerShell で「スクリプトの実行が無効」と出た場合は、方法A か方法B を使ってください。

デスクトップに **「やることリスト」** ができます。  
**ダブルクリック** するだけでアプリが開きます。

## アプリの使い方

1. やることを入力
2. **「追加する」** を押す
3. タスクを選んで **「完了にする」** または **「削除」**

データは `C:\Users\あなたの名前\.cursortest_tasks.json` に保存されます。  
以前 CLI で追加したタスクも、そのまま表示されます。

## 上級者向け（CLI）

```powershell
python C:\Users\あなたの名前\cursortest\tasks.py list
```

## テスト

```bash
python3 -m unittest discover -s tests -v
```

## ファイル構成

| ファイル | 説明 |
|---------|------|
| `tasks_app.py` | やることリスト（GUI アプリ） |
| `tasks.py` | コマンド版（上級者向け） |
| `textstats.py` | テキスト統計ツール |
