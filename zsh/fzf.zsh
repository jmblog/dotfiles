# fzf configuration
# ----------------------------------------------------------------------

# Set up fzf key bindings and fuzzy completion (cached)
_fzf_cache="$HOME/.cache/fzf-zsh.zsh"
if [[ ! -f "$_fzf_cache" || "$(command -v fzf)" -nt "$_fzf_cache" ]]; then
  mkdir -p "$HOME/.cache"
  fzf --zsh > "$_fzf_cache"
fi
source "$_fzf_cache"
unset _fzf_cache
