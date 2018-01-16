#!/usr/bin/env bash

function dots_install() {

  local DOTS_DIR=${1:-'.dotfiles'}

  [[ -d "$HOME/$DOTS_DIR" ]] && { echo 'Already installed.'; return; }

  for cmd in curl git vim zsh; do
    command -v $cmd >/dev/null 2>&1 || { echo >&2 "I require $cmd but it's not installed.  Aborting."; return; }
  done

  cd

  git clone \
    --separate-git-dir="$HOME/$DOTS_DIR" \
    git@github.com:nhoag/dotfiles.git \
    $(mktemp -d)

  git --git-dir="$HOME/$DOTS_DIR" --work-tree="$HOME" config status.showUntrackedFiles no

  git --git-dir="$HOME/$DOTS_DIR" --work-tree="$HOME" checkout .

  chsh -s $(which zsh)

  zsh

  cd -

}

dots_install "$@"

