export HOMEBREW_CASK_OPTS="--appdir=/Applications"
autoload -U colors && colors

if [[ ! -d $HOME/.modules/zgen ]]; then
  git clone https://github.com/tarjoilija/zgen.git ~/.modules/zgen
fi

# Zgen is "package manager" for zsh
source ~/.modules/zgen/zgen.zsh

if ! zgen saved; then
  echo "Creating a zgen save"
  # plugins
  zgen load zsh-users/zsh-syntax-highlighting
  zgen load zsh-users/zsh-history-substring-search
  zgen load zsh-users/zsh-completions src
  zgen load zsh-users/zaw
  zgen load nhoag/zsh-themes basic
  zgen save
fi

# Editor
if command -v nvim > /dev/null; then
  export EDITOR=nvim
else
  export EDITOR=vim
fi

# Less
export LESSSECURE=1

autoload -U zmv

# Readline
export WORDCHARS='*?[]~&;!$%^<>'

export LANG="en_US.UTF-8"

if [[ -f ~/.nix-profile/etc/profile.d/nix.sh ]]; then
  source ~/.nix-profile/etc/profile.d/nix.sh
fi

source ~/.zstyle
source ~/.zalias
source ~/.zfunction

if [ -f $HOME/.profile ]; then
  . $HOME/.profile
fi
