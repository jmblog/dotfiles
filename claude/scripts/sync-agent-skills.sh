#!/bin/bash
# agent-skills のスキルを自動的に ~/.dotfiles/claude/skills/ にリンク

AGENT_SKILLS_DIR="$HOME/.agents/skills"
CLAUDE_SKILLS_DIR="$HOME/.dotfiles/claude/skills"

# .agents/skills が存在しない場合はスキップ
if [ ! -d "$AGENT_SKILLS_DIR" ]; then
  exit 0
fi

# .dotfiles/claude/skills が存在しない場合は作成
mkdir -p "$CLAUDE_SKILLS_DIR"

# .agents/skills 内の各スキルをチェック
for skill_path in "$AGENT_SKILLS_DIR"/*; do
  if [ ! -d "$skill_path" ]; then
    continue
  fi

  skill_name=$(basename "$skill_path")
  link_path="$CLAUDE_SKILLS_DIR/$skill_name"

  # すでにディレクトリとして存在する場合（dotfiles 管理の独自スキル）はスキップ
  if [ -d "$link_path" ] && [ ! -L "$link_path" ]; then
    continue
  fi

  # シンボリックリンクがすでに存在し、正しいターゲットを指している場合はスキップ
  if [ -L "$link_path" ]; then
    current_target=$(readlink "$link_path")
    expected_target="../../../.agents/skills/$skill_name"
    if [ "$current_target" = "$expected_target" ]; then
      continue
    fi
    # 間違ったリンクの場合は削除
    rm "$link_path"
  fi

  # シンボリックリンクを作成
  ln -s "../../../.agents/skills/$skill_name" "$link_path"
done
