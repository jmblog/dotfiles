# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## セットアップとインストールコマンド

### 完全セットアップ
```bash
# 全てをインストール（GitHub用のSSHキー設定が必要）
./setup.sh
```

### 個別コンポーネントセットアップ
```bash
# 特定のコンポーネントをセットアップ
./git/setup.sh          # Git設定とGitHub CLI
./zsh/setup.sh           # Zshの補完とPureプロンプト
./vim/setup.sh           # Vim設定
./node/setup.sh          # VoltaによるNode.js
./ghostty/setup.sh       # Ghosttyターミナル設定
./wezterm/setup.sh       # WezTermターミナル設定

# パッケージインストール
./homebrew/brew.sh       # 開発ツールとユーティリティ
./homebrew/font.sh       # プログラミングフォント
./applist.sh             # インタラクティブアプリインストーラー
./macosdefaults.sh       # macOSシステム設定（メインセットアップではコメントアウト）
```

### テストと検証
```bash
# GitHubへのSSH接続を確認
ssh -T git@github.com

# インストールされたパッケージを確認
brew list

# シンボリックリンクが正常に動作していることを確認
ls -la ~/.zshrc ~/.gitconfig ~/.vimrc
```

## アーキテクチャ概要

これはアプリケーション/ツール別に整理されたモジュラー dotfiles リポジトリです：

- **メインセットアップ**: `setup.sh` が全コンポーネントのインストールを統括
- **コンポーネント構造**: 各ツールが独自のディレクトリに設定ファイルと `setup.sh` を持つ
- **シンボリックリンク戦略**: 設定ファイルはdotfilesディレクトリからホームディレクトリにシンボリックリンク
- **パッケージ管理**: ツールにはHomebrew、GUIアプリには手動ダウンロードを使用

### 主要コンポーネント

- **Git**: フック、グローバルgitignore/gitattributes、GitHub CLIを含む完全な設定
- **Zsh**: 複数ファイルに分割されたモジュラー設定（エイリアス、補完、履歴など）
- **ターミナル**: Ghostty と WezTerm の両方をサポート、設定ファイル付き
- **Node.js**: Volta で管理、npm設定付き
- **Vim**: カラースキームとプラグインを含むカスタム設定

### ファイル構成パターン

```
<tool>/
├── setup.sh           # インストールとシンボリックリンク作成
├── <configfile>       # メイン設定ファイル
└── <other-configs>    # その他のツール固有ファイル
```

### 前提条件

- macOSシステム
- GitHub アクセス用に設定されたSSHキー
- ツールとアプリダウンロード用のインターネット接続

## 重要な注意事項

- メインセットアップスクリプトは動作にGitHub SSH認証が必要
- 一部のステップはインタラクティブ（フォントインストール、アプリインストール）
- macOSデフォルト設定はメインセットアップでコメントアウトされているが利用可能
- 全てのシンボリックリンクはコピーではなくdotfilesディレクトリ内のファイルを指す