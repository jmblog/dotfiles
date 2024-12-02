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
prompt pure

# Load any local overrides
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

