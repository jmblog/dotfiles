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
  
  # mise の設定ファイルを信頼（存在する場合）
  for mise_file in .mise.toml .mise.local.toml mise.toml mise.local.toml; do
    if [ -f "$worktree_path/$mise_file" ]; then
      mise trust "$worktree_path/$mise_file"
      echo "✓ mise trust を実行しました: $mise_file"
    fi
  done

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

# Worktree Delete - wts で作成した worktree を削除
wtd() {
  local current_path main_repo

  # Gitリポジトリ内かチェック
  if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    echo "❌ エラー: Git リポジトリ内で実行してください"
    return 1
  fi

  # ワークツリーか判定（メインリポジトリでないことを確認）
  local git_dir=$(git rev-parse --git-dir 2>/dev/null)
  if [[ "$git_dir" == ".git" ]]; then
    echo "❌ エラー: ここはワークツリーではありません"
    return 1
  fi

  # wts で作成したワークツリーかチェック
  current_path=$(pwd)
  if [[ "$current_path" != ~/Projects/worktrees/* ]]; then
    echo "❌ エラー: このワークツリーは wts で作成されていません"
    return 1
  fi

  # メインリポジトリのパスを取得
  main_repo=$(git worktree list --porcelain | awk '/^worktree / {print $2; exit}')

  # メインリポジトリに移動
  cd "$main_repo" || {
    echo "❌ エラー: 元のリポジトリに移動できませんでした"
    return 1
  }

  # ワークツリーを削除
  git worktree remove "$current_path" || return 1
  
  # コードを最新化
  git pull && git cleanup

  # 成功メッセージ
  echo "✅ Worktree を削除しました: $current_path"
}
