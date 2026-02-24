# Completion settings

_brew_prefix="${HOMEBREW_PREFIX:-/opt/homebrew}"

if type brew &> /dev/null; then
  FPATH=$_brew_prefix/share/zsh/site-functions:$_brew_prefix/share/zsh-completions:$FPATH
fi

# Case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z} r:|[-_.]=**'

# Load zsh-autosuggestions
source $_brew_prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh

unset _brew_prefix

# Optimize zsh-autosuggestions
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=244"

# Additional completion optimizations
zstyle ':completion:*' menu select
zmodload zsh/complist
_comp_options+=(globdots)

# Use cache for completions
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path $ZSH_CACHE_DIR

# Optimize cd completion
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
