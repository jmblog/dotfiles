# volta → mise 完全移行 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** dotfiles から volta を完全撤去し、Node.js のバージョン管理を mise に一本化する。mise のインストール自体も dotfiles（Homebrew）に組み込み、個人端末で再現可能にする。

**Architecture:** volta が担っていた「グローバルデフォルト node + グローバル npm パッケージ」を mise に引き継ぐ。mise は `brew install mise` で導入し、`.zshrc` の activate を PATH 解決に変更してインストール方法非依存にする。zsh 設定は `.zshrc:12` が `zsh/*.zsh` を自動 source する仕組みのため、`zsh/volta.zsh` はファイル削除だけで無効化される。

**Tech Stack:** mise, Homebrew, zsh, Node.js (LTS)

## Global Constraints

- グローバルデフォルト node は `node@lts`（最新 LTS 追従）
- グローバル npm パッケージは mise バックエンド（`npm:` プレフィックス）で管理
- mise は Homebrew で管理（`brew install mise`）
- `.zshrc` の mise activate は PATH 解決（`mise activate zsh`）にしてインストール方法非依存にする
- スコープ外: 各プロジェクトの `.mise.toml`、brew 管理の `pnpm`
- この dotfiles はテストフレームワークを持たない。検証は各タスクの手動確認コマンドで行う

---

### Task 1: mise を Homebrew 管理下に追加

**Files:**
- Modify: `homebrew/brew.sh:12`（`brew install pnpm` の直後に追加）

**Interfaces:**
- Consumes: なし
- Produces: `brew install mise` 行（後続タスクの activate が前提とする mise 本体の入手経路）

- [ ] **Step 1: `brew install mise` を追加**

`homebrew/brew.sh` の `brew install pnpm`（12 行目）の直後に 1 行追加する:

```bash
brew install pnpm
brew install mise
brew install fzf
```

- [ ] **Step 2: 追加を確認**

Run: `grep -n "brew install mise" homebrew/brew.sh`
Expected: `13:brew install mise`（またはそれに近い行番号）で 1 件ヒット

- [ ] **Step 3: Commit**

```bash
git add homebrew/brew.sh
git commit -m "feat(mise): Homebrew で mise をインストールするよう追加"
```

---

### Task 2: `.zshrc` の mise activate をパス非依存に変更

**Files:**
- Modify: `zsh/.zshrc:64`

**Interfaces:**
- Consumes: Task 1 で導入される mise（`/opt/homebrew/bin/mise`。移行前の `~/.local/bin/mise` でも PATH 上にあれば動く）
- Produces: なし

- [ ] **Step 1: activate 行を書き換え**

`zsh/.zshrc:64` を変更する:

```zsh
# 変更前
eval "$(/Users/jimbo/.local/bin/mise activate zsh)"
# 変更後
eval "$(mise activate zsh)"
```

- [ ] **Step 2: 絶対パス直書きが消えたことを確認**

Run: `grep -n "mise activate" zsh/.zshrc`
Expected: `64:eval "$(mise activate zsh)"`（`/Users/jimbo/.local/bin` を含まない）

- [ ] **Step 3: 構文チェック（新しい zsh を起動してエラーが出ないこと）**

Run: `zsh -i -c 'echo zshrc-ok'`
Expected: `zshrc-ok` が出力され、mise 関連のエラーが出ない

- [ ] **Step 4: Commit**

```bash
git add zsh/.zshrc
git commit -m "refactor(zsh): mise activate をパス解決に変更しインストール方法非依存化"
```

---

### Task 3: volta の PATH 登録を削除

**Files:**
- Modify: `zsh/path.zsh:10`（`$HOME/.volta/bin` の行を削除）

**Interfaces:**
- Consumes: なし
- Produces: なし

- [ ] **Step 1: `$HOME/.volta/bin` の行を削除**

`zsh/path.zsh` の `path=(...)` 配列から 10 行目 `  $HOME/.volta/bin` を削除する。削除後の配列:

```zsh
path=(
  $HOME/bin
  $HOME/.local/bin
  /usr/local/{bin,sbin}
  /usr/local/opt/{coreutils/libexec/gnubin,openssl/bin,openjdk@11/bin}
  /usr/local/go/bin
  $HOME/go/bin
  $HOME/.rbenv/bin
  $HOME/.rd/bin
  $HOME/.opencode/bin
  $path
)
```

- [ ] **Step 2: volta 参照が消えたことを確認**

Run: `grep -n "volta" zsh/path.zsh`
Expected: ヒットなし（終了コード 1）

- [ ] **Step 3: Commit**

```bash
git add zsh/path.zsh
git commit -m "refactor(zsh): PATH から volta を削除"
```

---

### Task 4: volta 用 chpwd フックを削除

**Files:**
- Delete: `zsh/volta.zsh`

**Interfaces:**
- Consumes: なし
- Produces: なし（`.zshrc:12` の `for config_file ($HOME/.dotfiles/zsh/*.zsh(N))` が自動 source するため、ファイル削除で読み込み対象から外れる）

- [ ] **Step 1: `zsh/volta.zsh` を削除**

```bash
git rm zsh/volta.zsh
```

- [ ] **Step 2: ファイルが消えたこと・他から参照されていないことを確認**

Run: `ls zsh/volta.zsh 2>&1; grep -rn "reinstall-global-packages\|volta" zsh/ 2>/dev/null`
Expected: `ls` は "No such file"、`grep` はヒットなし

- [ ] **Step 3: Commit**

```bash
git commit -m "refactor(zsh): volta 用 reinstall-global-packages フックを削除"
```

---

### Task 5: `node/setup.sh` を mise ベースに書き換え

**Files:**
- Modify: `node/setup.sh`（全面書き換え）

**Interfaces:**
- Consumes: Task 1 で導入される mise（`brew.sh` は `setup.sh` 内で `node/setup.sh` より前に実行される。ただし本タスクの setup.sh は mise が PATH にある前提）
- Produces: グローバル `node@lts` と `npm:firebase-tools` を設定するセットアップ手順

- [ ] **Step 1: `node/setup.sh` の中身を書き換え**

`node/setup.sh` を以下の内容で置き換える:

```bash
# Set the latest LTS version of node as the global default
mise use -g node@lts

# Install global tools via mise's npm backend
# （node のバージョンと独立して管理されるため、切替時の再インストールが不要）
mise use -g npm:firebase-tools
```

- [ ] **Step 2: volta 参照が消えたことを確認**

Run: `grep -in "volta" node/setup.sh`
Expected: ヒットなし（終了コード 1）

- [ ] **Step 3: 構文チェック**

Run: `bash -n node/setup.sh && echo syntax-ok`
Expected: `syntax-ok`

- [ ] **Step 4: Commit**

```bash
git add node/setup.sh
git commit -m "feat(node): setup.sh を mise ベース（node@lts + npm:firebase-tools）に書き換え"
```

---

### Task 6: `node/npm.sh` を削除

**Files:**
- Delete: `node/npm.sh`

**Interfaces:**
- Consumes: なし
- Produces: なし（`node/npm.sh` は `setup.sh` から呼ばれていない。念のため参照確認する）

- [ ] **Step 1: どこからも呼ばれていないことを確認**

Run: `grep -rn "npm.sh" . --include="*.sh" | grep -v ".git/"`
Expected: ヒットなし（`node/npm.sh` 自身の定義以外に参照がない）

- [ ] **Step 2: `node/npm.sh` を削除**

```bash
git rm node/npm.sh
```

- [ ] **Step 3: Commit**

```bash
git commit -m "chore(node): 不要になった npm.sh を削除（mise 管理へ移行）"
```

---

### Task 7: この端末のクリーンアップと最終検証

このタスクは dotfiles のコード変更ではなく、実行中の端末を新設定に合わせて整える手動手順。実行者（ユーザー）が対話的に行う。

**Files:**
- なし（ランタイム操作のみ）

**Interfaces:**
- Consumes: Task 1〜6 の変更が反映済みであること
- Produces: なし

- [ ] **Step 1: mise にグローバル設定を反映**

Run:
```bash
mise use -g node@lts
mise use -g npm:firebase-tools
```
Expected: エラーなく完了。`~/.config/mise/config.toml` に `node = "lts"` 等が追記される

- [ ] **Step 2: volta をアンインストール**

Run:
```bash
volta uninstall 2>/dev/null; rm -rf ~/.volta ~/.last_node_version
```
Expected: エラーなく完了

- [ ] **Step 3: mise を brew 版に一本化（旧 curl 版バイナリを削除）**

`brew install mise` 済みでも、PATH で `~/.local/bin`（curl 版の位置）が
`/opt/homebrew/bin` より先に来るため、旧 curl 版バイナリが残っていると
`mise` はそちらに解決され続ける（activate 関数にも旧パスが焼き込まれる）。
データ/設定（`~/.config/mise`・`~/.local/share/mise`）はバイナリ位置と独立で
共有のため、旧バイナリを削除してもインストール済み node 等は失われない。

Run:
```bash
brew install mise         # 未導入なら
rm -f ~/.local/bin/mise   # 旧 curl 版バイナリを削除（データは残る）
```
Expected: `/opt/homebrew/bin/mise` のみが残る

- [ ] **Step 4: 新しいシェルで検証**

Run（新しいシェルを開いて）:
```bash
type mise           # → 関数（正常）。関数本体が /opt/homebrew/bin/mise を参照すること
command -v mise      # → /opt/homebrew/bin/mise（PATH 解決先）
which -a node       # → ~/.volta を含まないこと
node -v             # → LTS バージョンが返ること
firebase --version  # → バージョンが返ること
mise doctor         # → 致命的エラーがないこと
```
Expected: 上記すべてが期待どおり（volta フォールバック・旧 mise パスが消えている）

注: mise は activate 時に `mise` という名のシェル関数を定義するため、
`which mise` が関数を返すのは正常。判断は「関数本体が参照するバイナリパス」で行う。

- [ ] **Step 5: ブランチをマージ（finishing-a-development-branch スキルに従う）**

移行が検証できたら、`finishing-a-development-branch` スキルで main への統合方法（マージ / PR）を決める。

---

## Self-Review

**1. Spec coverage:**
- 決定1（volta 完全撤去） → Task 3・4・5・6・7
- 決定2（node@lts） → Task 5・7
- 決定3（npm: バックエンド、フック廃止） → Task 4・5
- 決定4（brew install、activate パス非依存） → Task 1・2
- 検証項目 → Task 7 Step 4
- 既存端末クリーンアップ手順 → Task 7
- スコープ外（プロジェクト `.mise.toml`、brew pnpm） → 触れていない ✓

**2. Placeholder scan:** TBD/TODO/曖昧記述なし。各コード変更ステップに実コードあり ✓

**3. Type consistency:** シェルスクリプト中心で型シグネチャなし。コマンド名・パス（`mise use -g node@lts`、`~/.volta/bin`、`node/setup.sh`）は全タスクで一貫 ✓
