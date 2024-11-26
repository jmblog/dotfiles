reinstall-global-packages() {
  # package.jsonが存在する場合のみ処理を続行
  if [[ ! -f "package.json" ]]; then
    return
  fi

  local current_node_version="$(node -v)"
  local last_node_version_file="$HOME/.last_node_version"
  local last_node_version=""

  if [ -f "$last_node_version_file" ]; then
    last_node_version="$(cat "$last_node_version_file")"
  fi

  if [ "$current_node_version" != "$last_node_version" ]; then
    echo "Node.js version changed from $last_node_version to $current_node_version"
    echo "Reinstalling global packages..."

    # グローバルパッケージリストを取得
    local global_packages=$(volta list --format plain | grep -v '^runtime' | awk '{print $1}' | sort -u)

    if [[ -n $global_packages ]]; then
      echo "$global_packages" | while read -r package; do
        if [[ -n $package ]]; then
          # 非同期でパッケージを再インストール
          (
            echo "Reinstalling $package"
            volta install "$package" &> /dev/null
          ) &
        fi
      done
      echo "Global packages reinstallation started in background."
    else
      echo "No global packages to reinstall."
    fi

    echo "$current_node_version" > "$last_node_version_file"
    echo "Global packages reinstalled."
  fi
}

autoload -U add-zsh-hook
add-zsh-hook chpwd reinstall-global-packages
reinstall-global-packages
