autoload -U colors && colors

# Command history configuration.
if [ -z "$HISTFILE" ]; then
  HISTFILE=$HOME/.zsh_history
fi

HISTSIZE=1000000
SAVEHIST=1000000

# Show history.
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
setopt HIST_IGNORE_SPACE

# Use Zgen package manager.
if [[ ! -d $HOME/.modules/zgen ]]; then
  git clone https://github.com/tarjoilija/zgen.git ~/.modules/zgen
fi

source ~/.modules/zgen/zgen.zsh

if ! zgen saved; then
  echo "Creating a zgen save"
  zgen load zsh-users/zsh-syntax-highlighting
  zgen load zsh-users/zsh-history-substring-search
  zgen load zsh-users/zsh-completions src
  zgen load nhoag/zsh-themes basic
  zgen save
fi

NORMAL_MODE="%{$fg[red]%}*%{$reset_color%}"
INSERT_MODE="%{$fg[yellow]%}<%{$reset_color%}"

function zle-line-init zle-keymap-select {
  RPS1="${${KEYMAP/vicmd/$NORMAL_MODE}/(main|viins)/}"
  RPS2=$RPS1
  zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select
zle -N edit-command-line

# Default to vi mode in zsh.
bindkey -v
bindkey -M vicmd 'z' edit-command-line
autoload -Uz edit-command-line

bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
bindkey '^b' backward-word
bindkey '^f' forward-word
bindkey '^d' delete-word

# Bind UP and DOWN arrow keys.
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# Bind UP and DOWN arrow keys (compatibility fallback
# for Ubuntu 12.04, Fedora 21, and MacOSX 10.9 users).
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Bind P and N for EMACS mode.
bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down

# Bind k and j for VI mode.
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

autoload -U zmv

autoload -Uz vcs_info
# %s - The current version control system, like git or svn.
# %r - The name of the root directory of the repository
# %S - The current path relative to the repository root directory
# %b - Branch information, like master
# %m - In case of Git, show information about stashes
# %u - Show unstaged changes in the repository
# %c - Show staged changes in the repository
zstyle ':vcs_info:*' enable git
# zstyle ':vcs_info:*' check-for-changes true
# zstyle ':vcs_info:git*+set-message:*' hooks git-untracked git-st
zstyle ':vcs_info:*' formats " %{$fg_bold[yellow]%}%b%{$reset_color%}%c%u"
# zstyle ':vcs_info:*' stagedstr " %{$fg[green]%}✔%{$reset_color%}"
# zstyle ':vcs_info:*' unstagedstr " %{$fg[red]%}✘%{$reset_color%}"
zstyle ':vcs_info:*' actionformats "%s→%b (%a)"

precmd() {
  vcs_info
}

setopt prompt_subst

PROMPT='%{$fg[blue]%}$(_fishy_collapsed_wd)${vcs_info_msg_0_} %{$fg[green]%}%# %{$reset_color%}'

# Fast Vim:Shell Switching.
function fancy-ctrl-z() {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

if [[ -f /usr/local/share/zsh/site-functions/_aws ]]; then
  . /usr/local/share/zsh/site-functions/_aws
fi

for file in ~/.{ah_profile,alias,work,function,export,path,private,zstyle}; do
  [[ -r "$file" ]] && [[ -f "$file" ]] && . "$file"
done

[[ -f "${HOME}/.nix-profile/etc/profile.d/nix.sh" ]] && . "${HOME}/.nix-profile/etc/profile.d/nix.sh"
# Added by Travis gem.
[[ -f "${HOME}/.travis/travis.sh" ]] && . "${HOME}/.travis/travis.sh"

