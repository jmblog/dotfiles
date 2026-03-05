#!/usr/bin/env bash
# Claude Code status line - inspired by pure prompt style

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
model=$(echo "$input" | jq -r '.model.display_name // ""')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
vim_mode=$(echo "$input" | jq -r '.vim.mode // empty')

# Shorten home directory to ~
short_cwd=$(echo "$cwd" | sed "s|^$HOME|~|")

# Get git branch (cached for 5 seconds)
CACHE_FILE="/tmp/statusline-git-cache"
CACHE_MAX_AGE=5

cache_is_stale() {
  [ ! -f "$CACHE_FILE" ] || \
  [ $(($(date +%s) - $(stat -f %m "$CACHE_FILE" 2>/dev/null || stat -c %Y "$CACHE_FILE" 2>/dev/null || echo 0))) -gt $CACHE_MAX_AGE ]
}

if cache_is_stale; then
  if git -C "$cwd" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
    dirty=""
    git -C "$cwd" diff --quiet 2>/dev/null && git -C "$cwd" diff --cached --quiet 2>/dev/null || dirty="*"
    echo "${branch}${dirty}" > "$CACHE_FILE"
  else
    echo "" > "$CACHE_FILE"
  fi
fi

git_branch=$(cat "$CACHE_FILE")

# Progress bar color based on usage
if [ "$used_pct" -ge 90 ] 2>/dev/null; then BAR_COLOR='\033[31m'
elif [ "$used_pct" -ge 70 ] 2>/dev/null; then BAR_COLOR='\033[33m'
else BAR_COLOR='\033[32m'; fi
RESET='\033[0m'

BAR_WIDTH=10
FILLED=$((used_pct * BAR_WIDTH / 100))
EMPTY=$((BAR_WIDTH - FILLED))
BAR=""
[ "$FILLED" -gt 0 ] && BAR=$(printf "%${FILLED}s" | tr ' ' '█')
[ "$EMPTY" -gt 0 ] && BAR="${BAR}$(printf "%${EMPTY}s" | tr ' ' '░')"

# Build parts
parts=()
parts+=("📁 $short_cwd")
if [ -n "$git_branch" ]; then
  clean_branch="${git_branch%\*}"
  if [ "$clean_branch" != "$git_branch" ]; then
    parts+=("🌿 ${clean_branch}\033[38;5;218m*\033[0m")
  else
    parts+=("🌿 $git_branch")
  fi
fi
[ -n "$model" ] && parts+=("$model")
parts+=("$(printf "${BAR_COLOR}%s${RESET} %s%%" "$BAR" "$used_pct")")
[ -n "$vim_mode" ] && parts+=("[$vim_mode]")

# Join with separator
printf "%b" "${parts[0]}"
for part in "${parts[@]:1}"; do
  printf " | %b" "$part"
done
printf "\n"
