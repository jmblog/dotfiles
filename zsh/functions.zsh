select_worktree() {
  local worktrees
  worktrees=$(git worktree list --porcelain | awk '/worktree / {print $2}')
  if [[ -z "$worktrees" ]]; then
    echo "No worktrees found."
    return 1
  fi
  local selected
  selected=$(echo "$worktrees" | fzf)
  if [[ -n "$selected" ]]; then
    echo "$selected"
    cd "$selected"
  fi
}

# Worktree Setup - Create a new worktree with dependencies
wts() {
  local repo_name=$(basename $(pwd))
  local branch_name=$1
  local worktree_path=~/Projects/worktrees/${repo_name}-${branch_name}

  if [[ -z "$branch_name" ]]; then
    echo "Usage: wts <branch-name>"
    return 1
  fi

  # worktree 用ディレクトリが存在しない場合は作成
  mkdir -p ~/Projects/worktrees

  # ブランチが存在するか確認
  if git rev-parse --verify "$branch_name" &>/dev/null; then
    # 既存ブランチを使用
    echo "📌 既存ブランチ '$branch_name' を使用します"
    git worktree add "$worktree_path" "$branch_name" || return 1
  else
    # 新しいブランチを作成
    echo "🌱 新しいブランチ '$branch_name' を作成します"
    git worktree add "$worktree_path" -b "$branch_name" || return 1
  fi

  # .env をコピー（存在する場合）
  if [ -f .env ]; then
    cp .env "$worktree_path/"
    echo "✓ .env をコピーしました"
  fi

  # .env.local をコピー（存在する場合）
  if [ -f .env.local ]; then
    cp .env.local "$worktree_path/"
    echo "✓ .env.local をコピーしました"
  fi
  
  # 依存関係をインストール（package.json がある場合）
  if [ -f package.json ]; then
    echo "📦 依存関係をインストール中..."
    (cd "$worktree_path" && npm install)
    echo "✓ 依存関係をインストール完了"
  fi

  echo "✅ Worktree を作成しました: $worktree_path"

  # 自動的に worktree に移動
  cd "$worktree_path"
}
