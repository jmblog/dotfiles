# Claude Code 設定

このディレクトリには、Claude Code の設定とスクリプトが含まれています。

## ディレクトリ構成

```
~/.dotfiles/claude/
├── settings.json          # Claude Code 設定ファイル
├── scripts/              # 自動化スクリプト
│   └── sync-agent-skills.sh
├── skills/               # スキルディレクトリ
│   ├── ui-skills/       # dotfiles管理の独自スキル
│   ├── find-skills@     # agent-skillsへのシンボリックリンク
│   ├── problem-solving@ # agent-skillsへのシンボリックリンク
│   └── review-pr@       # agent-skillsへのシンボリックリンク
└── README.md            # このファイル
```

## 自動スキル同期

### 概要

`scripts/sync-agent-skills.sh` は、[agent-skills](https://github.com/anthropics/agent-skills) リポジトリのスキルを自動的に `~/.dotfiles/claude/skills/` にシンボリックリンクするスクリプトです。

### 動作仕様

- **同期元**: `~/.agents/skills/`
- **同期先**: `~/.dotfiles/claude/skills/`
- **実行タイミング**: Claude Code 起動時（SessionStart フック）
- **スキップ対象**: dotfiles で管理している独自スキル（`ui-skills/` など）

### 仕組み

1. `~/.agents/skills/` 内の各スキルをチェック
2. すでにディレクトリとして存在する場合（dotfiles管理の独自スキル）はスキップ
3. シンボリックリンクが正しく設定されている場合はスキップ
4. 間違ったリンクや存在しないリンクは削除して再作成

### 手動実行

```bash
bash ~/.dotfiles/claude/scripts/sync-agent-skills.sh
```

### 確認方法

```bash
# リンク状態を確認
ls -la ~/.dotfiles/claude/skills/

# リンク先にアクセスできるか確認
file ~/.dotfiles/claude/skills/*
```

### 新しいスキルの追加

agent-skills に新しいスキルが追加された場合、次回の Claude Code 起動時に自動的にリンクが作成されます。
