# .zshrc

# Performance optimization: Compile if needed
if [[ ! -f ~/.zshrc.zwc || ~/.zshrc -nt ~/.zshrc.zwc ]]; then
  zcompile ~/.zshrc
fi

# Set ZDOTDIR if not already set
: ${ZDOTDIR:=$HOME/.dotfiles/zsh}

# Load separate config files
for config_file ($ZDOTDIR/*.zsh(N)); do
  source $config_file
done

# Load and initialize the completion system
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# Setup pure prompt
autoload -U promptinit; promptinit
prompt pure

# Load any local overrides
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

