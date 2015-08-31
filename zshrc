export HOMEBREW_CASK_OPTS="--appdir=/Applications"
autoload -U colors && colors
## Command history configuration
if [ -z "$HISTFILE" ]; then
    HISTFILE=$HOME/.zsh_history
fi

HISTSIZE=1000000
SAVEHIST=1000000

# Show history
case $HIST_STAMPS in
  "mm/dd/yyyy") alias history='fc -fl 1' ;;
  "dd.mm.yyyy") alias history='fc -El 1' ;;
  "yyyy-mm-dd") alias history='fc -il 1' ;;
  *) alias history='fc -l 1' ;;
esac

setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups # ignore duplication command history list
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt share_history # share command history data
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS

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
  zgen load nhoag/zsh-themes basic
  zgen save
fi

# bind UP and DOWN arrow keys
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# bind UP and DOWN arrow keys (compatibility fallback
# for Ubuntu 12.04, Fedora 21, and MacOSX 10.9 users)
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# bind P and N for EMACS mode
bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down

# bind k and j for VI mode
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

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
