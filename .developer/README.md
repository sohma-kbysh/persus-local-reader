# プラトン『ソクラテスの弁明』ローカル読書環境

Perseus プロジェクトが公開しているデータを用いた、プラトン『ソクラテスの弁明』(*Apology*) のローカル読書環境です。

## 使い方（読者の方へ）

専門知識がなくても使えます。次の手順で読み始められます。

1. フォルダの中にある次のアプリを**ダブルクリック**します。

   ```text
   Open Plato Apology.app
   ```

2. 自動的にお使いのパソコンの中だけで小さな「サーバー」が起動し、続けてブラウザ（Safari や Chrome など）が開きます。インターネットにアップロードされるわけではなく、すべてあなたのパソコンの中で完結します。
3. ブラウザにギリシア語原文が表示されます。**ギリシア語の単語をクリック**すると、その単語の形態分析（品詞・格・活用形など）を示す「morph（形態）パネル」が開きます。これは辞書を都度引く手間を省くための補助機能です。
4. 読み終えたら、そのままブラウザやアプリを閉じてしまって構いません。裏で動いているサーバーは、8時間ほどアクセスがないと自動的に停止するので、後片付けを気にする必要はありません。

macOS が「このファイルを実行してもよいですか」といった確認を表示した場合は、「開く」を選んでください（インターネット経由でダウンロードしたアプリに対する標準的な確認です）。読書環境は `http://127.0.0.1:8000/` というアドレスで、あなたのパソコンの中だけで動作します。

### アップデートのしかた

GitHub 上の最新版に更新したいときは、次のアプリをダブルクリックしてください。

```text
Update Plato Apology.app
```

これまでにキャッシュした形態分析データ（単語の解析結果）はそのまま保持されつつ、GitHub から最新のファイル一式を取得し、読書環境を再度開いてくれます。

## いま何がローカルにあるか

- ギリシア語本文は `.developer/app/data/apology.json` にローカル保存されています。
- 生成された読書画面 `app/index.html` は、インターネット接続なしで動く静的なローカルページです。
- ギリシア語の単語をクリックすると、ローカルの「morph（形態）パネル」が開きます。
- `scripts/fetch_morph.py` は、『ソクラテスの弁明』本文に実際に出てくる語形だけを対象に、Perseus Hopper の形態分析ページをキャッシュ（保存）できます。

morph パネルは、まず `.developer/app/data/morph.json` にキャッシュ済みの Perseus 解析があればそれを使います。なければ、正規化した語形や `hib_lemmas.sql` 由来のローカルな見出し語候補を代わりに表示します。

---

以下は開発者向けの技術的な説明です（英語）。

# Plato Apology Local Reader

Local reading environment for Plato's *Apology* using openly distributed Perseus data.

## For Readers

On macOS, double-click:

```text
Open Plato Apology.app
```

It starts the local reader and opens your browser. The reader stops itself
automatically after about 8 hours without access.

To update this folder from GitHub, double-click:

```text
Update Plato Apology.app
```

The updater preserves locally cached morphology data, pulls the latest files
from GitHub, and opens the reader again.

If macOS asks whether the file may run, choose to open it. The reader runs only
on your own computer at `http://127.0.0.1:8000/`.

## What is local now

- The Greek text is stored locally in `.developer/app/data/apology.json`.
- The generated reader in `app/index.html` works as a static local page.
- Clicking a Greek word opens a local "morph" panel.
- `scripts/fetch_morph.py` can cache Perseus Hopper morph pages for only the
  word forms that appear in the Apology.

The morph panel first uses `.developer/app/data/morph.json` when a cached Perseus analysis
is available. Otherwise it falls back to normalized forms and local lemma
candidates from `hib_lemmas.sql`.

## Terminal

```sh
python3 .developer/scripts/server.py 8000
```

Then open:

```text
http://localhost:8000/
```

## Fetch Perseus Morph Data

The official `hib_parses.tar.gz` download repeatedly terminated early from this
network, so this project uses a resumable, Apology-only cache of Hopper's morph
pages instead.

Fetch the first 20 word forms in reading order:

```sh
python3 .developer/scripts/fetch_morph.py --limit 20 --delay 2.0
```

Continue toward all Apology word forms:

```sh
python3 .developer/scripts/fetch_morph.py --delay 2.0
```

When the reader is served with `.developer/scripts/server.py`, clicking an uncached word
fetches just that word form on demand and writes it to `.developer/app/data/morph.json`.

Perseus may return `429 Too Many Requests`; the batch script waits and retries.
The ad hoc click handler reports the 429 and lets you retry later. Both paths
write `.developer/app/data/morph.json`, so it is safe to stop and resume.

## Data Sources

- Apology TEI XML: `PerseusDL/canonical-greekLit`
- Lemma dump: Perseus Hopper official open-source download page
