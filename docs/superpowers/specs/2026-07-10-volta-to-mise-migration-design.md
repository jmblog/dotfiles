# volta → mise 完全移行 設計ドキュメント

- 日付: 2026-07-10
- 対象: dotfiles（Node.js のバージョン管理）

## 背景 / 目的

社内の各プロジェクトでは mise を導入済み。個人環境も mise に一本化し、それを
dotfiles で管理することで個人用端末でも再現可能にしたい。

現状はすでに mise と volta が併存している:

| 項目 | 状態 |
|------|------|
| mise | `~/.local/bin/mise`（公式 curl インストーラのデフォルト位置）に手動インストール済み。`zsh/.zshrc:64` で activate。node/npm/pnpm/python/ruby/java 等を管理（node は複数バージョン導入済み） |
| mise グローバル node | **未設定**（`node does not have a version set`）→ プロジェクト外では volta の node にフォールバック |
| volta | `~/.volta/bin` にインストール、PATH 通し済み。`node/setup.sh` でインストールし、グローバルデフォルト node を提供 |
| mise インストール | **どの dotfiles スクリプトにも存在しない**（手動インストールのまま） |

つまり移行は「ゼロから」ではなく、**volta が担っている“グローバルのデフォルト node +
グローバル npm パッケージ”を mise に引き継ぎ、volta 関連コードを撤去し、mise の
インストール自体を dotfiles に組み込む**仕上げ作業が中心。

## 決定事項

| # | 論点 | 決定 |
|---|------|------|
| 1 | ゴール | volta 完全撤去・mise へ一本化。dotfiles で再現可能にする |
| 2 | グローバルデフォルト node | `node@lts`（最新 LTS 追従。volta の挙動に最も近い） |
| 3 | グローバル npm パッケージ | mise バックエンド（`npm:` プレフィックス）で管理。`reinstall-global-packages` フックは廃止 |
| 4 | mise インストール方法 | Homebrew（`brew install mise`）。`.zshrc` は PATH 解決の `mise activate` にしてインストール方法非依存にする |

## ファイル変更

### 1. `homebrew/brew.sh` — mise を brew 管理下に
- `brew install mise` を追加（`brew install pnpm` 付近）。

### 2. `zsh/.zshrc:64` — activate をパス非依存に
- 変更前: `eval "$(/Users/jimbo/.local/bin/mise activate zsh)"`
- 変更後: `eval "$(mise activate zsh)"`
- brew インストール（`/opt/homebrew/bin`）でも curl 版でも動くようになる。

### 3. `zsh/path.zsh:10` — volta PATH 削除
- `path=(...)` 内の `$HOME/.volta/bin` の行を削除。

### 4. `zsh/volta.zsh` — ファイルごと削除
- chpwd フック `reinstall-global-packages` は不要。mise は node バージョンと独立して
  グローバルツールを管理するため、volta 特有の「node 切替時にグローバルパッケージが
  消える」問題自体が消滅する（＝あのフックの存在理由がなくなる）。
- `.zshrc:12` の `for config_file ($HOME/.dotfiles/zsh/*.zsh(N))` が自動 source する
  仕組みのため、ファイル削除だけで読み込み対象から外れる。
- 副産物の `~/.last_node_version` はクリーンアップ対象（下記手順）。

### 5. `node/setup.sh` — mise ベースに全面書き換え
volta 関連（`curl get.volta.sh` / `VOLTA_HOME` / `volta install`）は全削除。

```bash
# グローバルデフォルト node（最新 LTS 追従）
mise use -g node@lts

# グローバルツールを mise バックエンドで管理
mise use -g npm:firebase-tools
```

- corepack は node 同梱のため個別管理不要。yarn/pnpm が必要なら
  `mise use -g pnpm@latest` 等を追記する（現状の必須要件ではない）。

### 6. `node/npm.sh` — 廃止（ファイル削除）
- `npm update -g npm` / `firebase-tools` / `corepack` は mise 管理 or node 同梱で不要。

## 既存端末（この端末）のクリーンアップ手順

dotfiles 反映後、手動で 1 回だけ実行:

```bash
mise use -g node@lts
mise use -g npm:firebase-tools
volta uninstall 2>/dev/null; rm -rf ~/.volta ~/.last_node_version
brew install mise   # 既存の ~/.local/bin/mise から brew 版へ寄せる（任意）
```

## 検証項目

- 新しいシェルで `which mise` が brew パス（`/opt/homebrew/bin/mise`）を指す
- プロジェクト外で `node -v` が mise の LTS を返す（volta フォールバックでない）
- `which -a node` に `~/.volta` が出ない
- `firebase --version` が動く
- `mise doctor` にエラーが出ない

## スコープ外（今回触らない）

- 各プロジェクトの `.mise.toml`（社内側で管理済み）
- brew 管理の `pnpm`（既に mise にもあるが、重複整理は別件）
