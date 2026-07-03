# cursortest

Cursor + GitHub + Python で作った、実用的な CLI ツール集です。

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
