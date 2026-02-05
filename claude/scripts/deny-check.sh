#!/bin/bash

# JSON 入力を読み取り、コマンドとツール名を抽出
input=$(cat)
command=$(echo "$input" | jq -r '.tool_input.command' 2>/dev/null || echo "")
tool_name=$(echo "$input" | jq -r '.tool_name' 2>/dev/null || echo "")

# Bash コマンドのみをチェック
if [ "$tool_name" != "Bash" ]; then
  exit 0
fi

# settings.json から拒否パターンを読み取り
settings_file="$HOME/.claude/settings.json"

# Bash コマンドの全拒否パターンを取得
deny_patterns=$(jq -r '.permissions.deny[] | select(startswith("Bash(")) | .[5:-1]' "$settings_file" 2>/dev/null)

# 空白を削除する関数
trim_whitespace() {
  local str="$1"
  str="${str#"${str%%[![:space:]]*}"}"
  str="${str%"${str##*[![:space:]]}"}"
  echo "$str"
}

# コマンドが拒否パターンにマッチするかチェックする関数
matches_deny_pattern() {
  local cmd="$1"
  local pattern="$2"
  
  cmd=$(trim_whitespace "$cmd")
  [[ "$cmd" == $pattern ]]
}

# パターンマッチング処理を行う関数
check_command_against_patterns() {
  local cmd="$1"
  
  while IFS= read -r pattern; do
    [ -z "$pattern" ] && continue
    
    if matches_deny_pattern "$cmd" "$pattern"; then
      echo "Error: コマンドが拒否されました: '$cmd' (パターン: '$pattern')" >&2
      exit 2
    fi
  done <<<"$deny_patterns"
}

# コマンド全体をチェック
check_command_against_patterns "$command"

# コマンドを論理演算子で分割して各部分をチェック
split_and_check_command() {
  local cmd="$1"
  local temp_cmd
  
  # セミコロン、&& と || で分割
  temp_cmd="${cmd//;/$'\n'}"
  temp_cmd="${temp_cmd//&&/$'\n'}"
  temp_cmd="${temp_cmd//\|\|/$'\n'}"
  
  local IFS=$'\n'
  for cmd_part in $temp_cmd; do
    # 空の部分をスキップ
    cmd_part=$(trim_whitespace "$cmd_part")
    [ -z "$cmd_part" ] && continue
    
    check_command_against_patterns "$cmd_part"
  done
}

split_and_check_command "$command"

# コマンドを許可
exit 0