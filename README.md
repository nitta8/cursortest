# cursortest

Cursor + GitHub + Python の動作確認用デモです。

## できること（このリポジトリで試したこと）

1. **Cursor（Agent）** — Python コードとテストを自動生成
2. **Git / GitHub** — ブランチ作成 → コミット → プッシュ → Pull Request
3. **Python** — CLI ツールの実装とユニットテスト

## 使い方

```bash
# テキスト統計
python3 textstats.py "Hello, Cursor and GitHub!"

# 標準入力から読み込み
echo -e "foo bar\nfoo baz" | python3 textstats.py --top 3

# テスト実行
python3 -m unittest discover -s tests -v
```

## ファイル構成

| ファイル | 説明 |
|---------|------|
| `textstats.py` | 文字数・行数・単語数を数える CLI |
| `tests/test_textstats.py` | ユニットテスト |
| `test.py` | 初期ファイル（空） |
