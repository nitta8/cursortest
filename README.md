# cursortest

**やることリスト** — ボタン操作だけで使えるタスク管理アプリです。

## Windows で使う

### あなたがやること（これだけ）

PowerShell に **この1行** をコピー＆ペーストして Enter:

```powershell
Invoke-WebRequest "https://raw.githubusercontent.com/nitta8/cursortest/main/install.cmd" -OutFile "$env:USERPROFILE\Desktop\setup.cmd"; cmd /c "%USERPROFILE%\Desktop\setup.cmd"
```

あとは自動で:

1. ダウンロード
2. インストール
3. デスクトップに「やることリスト」作成
4. アプリ起動

---

## アプリの使い方

1. やることを入力
2. **「追加する」** を押す
3. タスクを選んで **「完了にする」** または **「削除」**

データは `C:\Users\あなたの名前\.cursortest_tasks.json` に保存されます。

---

## 2回目以降

デスクトップの **「やることリスト」** をダブルクリックするだけ。

## ファイル構成

| ファイル | 説明 |
|---------|------|
| `tasks_app.py` | やることリスト（GUI アプリ） |
| `install.cmd` | Windows 用インストーラー |
| `tasks.py` | コマンド版（上級者向け） |
