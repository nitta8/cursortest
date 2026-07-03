# cursortest

Cursor + GitHub + Python で作った、実用的な CLI ツール集です。

## Windows で一番かんたん（Git 不要）

PowerShell を開いて、**この1行だけ** コピー＆ペーストしてください。

```powershell
irm https://raw.githubusercontent.com/nitta8/cursortest/main/install.ps1 | iex
```

これだけで以下が自動で行われます。

1. Python の有無を確認
2. GitHub からダウンロード
3. `C:\Users\あなたの名前\cursortest` にインストール
4. `C:\Users\あなたの名前\tasks.cmd` を作成

インストール後:

```powershell
tasks add "牛乳を買う"
tasks list
tasks done 1
```

`tasks` が見つからない場合は、**今すぐ** 次のどちらか:

```powershell
.\tasks.cmd add "牛乳を買う"
python "$env:USERPROFILE\cursortest\tasks.py" list
```

再インストール後もダメなら:

```powershell
. $PROFILE
tasks list
```

> Python が未インストールの場合は、表示された案内に従って Python を入れてから、もう一度上の1行を実行してください。

## ツール一覧

### tasks.py — タスク管理（おすすめ）

やることをメモして、完了管理できます。データはローカルの JSON ファイルに保存されます。

```bash
# タスクを追加
python3 tasks.py add "牛乳を買う"
python3 tasks.py add "レポート提出" --due 2026-07-10

# 未完了タスクを表示
python3 tasks.py list

# 完了にする / 削除
python3 tasks.py done 1
python3 tasks.py delete 2

# 完了済みタスクを一括削除
python3 tasks.py clear-done
```

保存先のデフォルト: `~/.cursortest_tasks.json`  
別ファイルを使う場合: `--file ./my_tasks.json`

### textstats.py — テキスト統計

```bash
python3 textstats.py "Hello, Cursor and GitHub!"
echo -e "foo bar\nfoo baz" | python3 textstats.py --top 3
```

## テスト

```bash
python3 -m unittest discover -s tests -v
```

## ファイル構成

| ファイル | 説明 |
|---------|------|
| `tasks.py` | タスク管理 CLI |
| `textstats.py` | 文字数・行数・単語数を数える CLI |
| `tests/` | ユニットテスト |
