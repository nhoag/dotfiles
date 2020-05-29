# See 'man zshall' for comprehensive zsh documentation.
#
# Store color and style attributes (bold, underline and so on) in the
# associative array color.
autoload -U colors && colors

# Set the file to use for command history.
if [ -z "$HISTFILE" ]; then
  HISTFILE=$HOME/.zsh_history
fi

# Command history memory size.
HISTSIZE=1000000 # max number of events in the internal history list
SAVEHIST=1000000 # max number of events in the history file

# Show history. Set HIST_STAMPS variable as below to display a formatted date
# with the history command. Default is numeric index only.
case $HIST_STAMPS in
  "mm/dd/yyyy") alias history='fc -fl 1' ;;
  "dd.mm.yyyy") alias history='fc -El 1' ;;
  "yyyy-mm-dd") alias history='fc -il 1' ;;
  *) alias history='fc -l 1' ;;
esac

setopt EXTENDED_HISTORY     # : <beginning time>:<elapsed seconds>;<command>
setopt HIST_FIND_NO_DUPS    # do not display non-contiguous dupes
setopt HIST_IGNORE_ALL_DUPS # replace historical dupes with latest command
setopt HIST_IGNORE_SPACE    # do not store commands prefixed with space
setopt HIST_REDUCE_BLANKS   # remove superfluous blanks from command
setopt HIST_SAVE_NO_DUPS    # prune older dupes
setopt HIST_VERIFY          # load command for editing with history expansion
setopt SHARE_HISTORY        # import and append new commands to history file

# Use Zgen package manager.
if [[ ! -d $HOME/.modules/zgen ]]; then
  git clone https://github.com/tarjoilija/zgen.git ~/.modules/zgen
fi

source ~/.modules/zgen/zgen.zsh

function zle-line-init zle-keymap-select {
  # This prompt is displayed on the right-hand side of the screen when the
  # primary prompt is being displayed on the left. This does not work if the
  # SINGLE_LINE_ZLE option is set. It is expanded in the same way as PS1.
  RPS1="${${KEYMAP/vicmd/$NORMAL_MODE}/(main|viins)/$INSERT_MODE}"
  # This prompt is displayed on the right-hand side of the screen when the
  # secondary prompt is being displayed on the left. This does not work if the
  # SINGLE_LINE_ZLE option is set. It is expanded in the same way as PS2.
  RPS2=$RPS1
  # Force the prompts on both the left and right of the screen to be
  # re-expanded, then redisplay the edit buffer. This reflects changes both to
  # the prompt variables themselves and changes in the expansion of the values
  # (for example, changes in time or directory, or changes to the value of
  # variables referred to by the prompt). Otherwise, the prompt is only
  # expanded each time zle starts, and when the display as been interrupted by
  # output from another part of the shell (such as a job notification) which
  # causes the command line to be reprinted.
  zle reset-prompt
}
# Executed every time the line editor is started to read a new line of input.
zle -N zle-line-init
# Executed every time the keymap changes, i.e. the special parameter KEYMAP is
# set to a different value, while the line editor is active. Initialising the
# keymap when the line editor starts does not cause the widget to be called.
# The value $KEYMAP within the function reflects the new keymap. The old keymap
# is passed as the sole argument. This can be used for detecting switches
# between the vi command (vicmd) and insert (usually main) keymaps.
zle -N zle-keymap-select
# Edit the command line with an external editor.
zle -N edit-command-line

# Ctrl+Z to background a job, then Ctrl+Z again to foreground it.
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

# Load plugins and save.
if ! zgen saved; then
  echo "Creating a zgen save"
  # Additional completion definitions.
  zgen load zsh-users/zsh-completions src
  # Suggests commands as you type based on history and completions.
  zgen load zsh-users/zsh-autosuggestions
  zgen load nhoag/zsh-themes basic
  # zsh-syntax-highlighting.zsh wraps ZLE widgets. It must be sourced after all
  # custom widgets have been created (i.e., after all zle -N calls and after
  # running compinit). Widgets created later will work, but will not update the
  # syntax highlighting.
  zgen load zsh-users/zsh-syntax-highlighting
  # zsh-syntax-highlighting must be loaded before zsh-history-substring-search.
  zgen load zsh-users/zsh-history-substring-search
  zgen save
fi

# Display a red star on the right side when in NORMAL mode.
NORMAL_MODE="%{$fg[red]%}*%{$reset_color%}"
# Display a yellow angle bracket on the right side when in INSERT mode.
INSERT_MODE="%{$fg[yellow]%}<%{$reset_color%}"

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=magenta"

# Default to vi mode in zsh.
bindkey -v

# Edit the command line with an external editor.
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

# Bind return for autosuggestions
bindkey '^\n' autosuggest-execute

autoload -U zmv # A command for renaming files by means of shell patterns.

# Main function that runs all VCS backends and assembles data into
# ${vcs_info_msg_*_}.
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

# Include up-to-date VCS information in the prompt.
precmd() {
  vcs_info
}

# If set, parameter expansion, command substitution and arithmetic expansion are
# performed in prompts. Substitutions within prompts do not affect the command
# status.
setopt prompt_subst

PROMPT='%{$fg[blue]%}$(_fishy_collapsed_wd)${vcs_info_msg_0_} %{$fg[green]%}%# %{$reset_color%}'

# Source several dotfiles.
for file in ~/.{ah_profile,alias,work/shell/config,function,export,path,private,zstyle}; do
  [[ -r "$file" ]] && [[ -f "$file" ]] && . "$file"
done

# Source OS-specific dotfile.
case "$OSTYPE" in
  darwin*)
    OSFILE="$HOME/.darwin"
    ;;
  *)
    OSFILE="$HOME/.linux"
    ;;
esac
[[ -r "$OSFILE" ]] && [[ -f "$OSFILE" ]] && . "$OSFILE"

