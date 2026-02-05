# .zshrc

# Performance optimization: Compile if needed
if [[ ! -f ~/.zshrc.zwc || ~/.zshrc -nt ~/.zshrc.zwc ]]; then
  zcompile ~/.zshrc
fi

# Load separate config files
for config_file ($HOME/.dotfiles/zsh/*.zsh(N)); do
  source $config_file
done

# Load and initialize the completion system
autoload -Uz compinit
if [[ -n ${HOME}/.dotfiles/zsh/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# Setup pure prompt
autoload -U promptinit; promptinit
# Show git stash status
zstyle :prompt:pure:git:stash show yes

prompt pure

# Load any local overrides
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/jimbo/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

# bun completions
[ -s "/Users/jimbo/.bun/_bun" ] && source "/Users/jimbo/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
