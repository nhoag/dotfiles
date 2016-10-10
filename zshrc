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

# Default to vi mode in zsh
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

autoload -U zmv

autoload -Uz vcs_info
# %s - The current version control system, like git or svn.
# %r - The name of the root directory of the repository
# %S - The current path relative to the repository root directory
# %b - Branch information, like master
# %m - In case of Git, show information about stashes
# %u - Show unstaged changes in the repository
# %c - Show staged changes in the repository
zstyle ':vcs_info:*' enable git svn
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
GIT_PROMPT='${vcs_info_msg_0_}'
PROMPT="%{$fg[blue]%}%/$GIT_PROMPT %{$fg[green]%}%# %{$reset_color%}"

if [[ -f $HOME/.nix-profile/etc/profile.d/nix.sh ]]; then
  . $HOME/.nix-profile/etc/profile.d/nix.sh
fi

if [[ -f $HOME/.profile ]]; then
  . $HOME/.profile
fi

#RPROMPT=''
#ASYNC_PROC=0
#function async_build_prompt() {
#    function async() {
#        # save to temp file
#        # sleep 2 && printf "%s" "$(date)" > "${HOME}/.zsh_tmp_prompt"
#
#        # signal parent
#        kill -USR1 $$
#    }
#
#    # do not clear RPROMPT, let it persist
#
#    # kill child if necessary
#    if [[ "${ASYNC_PROC}" != 0 ]]; then
#        kill -s HUP $ASYNC_PROC >/dev/null 2>&1 || :
#    fi
#
#    # start background computation
#    async &!
#    ASYNC_PROC=$!
#}
#
#async_build_prompt &!
#
#function TRAPUSR1() {
#    # read from temp file
#    RPROMPT="$(cat ${HOME}/.zsh_tmp_prompt)"
#
#    # reset proc number
#    ASYNC_PROC=0
#
#    # redisplay
#    zle && zle reset-prompt
#}

# added by travis gem
[[ -f "${HOME}/.travis/travis.sh" ]] && . "${HOME}/.travis/travis.sh"

[[ -e "${HOME}/.iterm2_shell_integration.zsh" ]] && . "${HOME}/.iterm2_shell_integration.zsh"
