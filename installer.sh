#!/usr/bin/env bash

function dots() {
  git --git-dir="$HOME/$DOTS_DIR" --work-tree="$HOME" "$@"
}

function install() {

  local DOTS_DIR=${1:-'.dotfiles'}

  requirements

  cd

  git clone \
    --separate-git-dir="$HOME/$DOTS_DIR" \
    git@github.com:nhoag/dotfiles.git \
    $(mktemp -d)

  dots config status.showUntrackedFiles no

  dots checkout .

  chsh -s $(which zsh)

  zsh

  cd -

}

function requirements() {

  [[ -d "$HOME/$DOTS_DIR" ]] && { echo 'Already installed.'; return; }

  for cmd in curl git vim zsh; do
    command -v $cmd >/dev/null 2>&1 || { echo >&2 "I require $cmd but it's not installed.  Aborting."; return; }
  done

}

dots_install "$@"

