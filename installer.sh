#!/usr/bin/env bash

# Bail on any error.
set -e
set -o pipefail

# Convenience function for calling special dotfiles git.
function dots() {
  git \
    --git-dir="$HOME/$DOTS_DIR" \
    --work-tree="$HOME" \
    "$@"
}

function install() {

  cd

  # Clone to a throw-away location.
  git clone \
    --separate-git-dir="$HOME/$DOTS_DIR" \
    git@github.com:nhoag/dotfiles.git \
    "$(mktemp -d)"

  dots config status.showUntrackedFiles no
  dots checkout .

  # Switch the default shell to zsh (requires sudo).
  chsh -s "$(which zsh)"

  # Use zsh right now (and trigger zgen build).
  zsh

  cd -

}

# Main installer function.
function main() {

  local DOTS_DIR=${1:-'.dotfiles'}

  [[ -d "$HOME/$DOTS_DIR" ]] && {
    echo 'Already installed.'
    return
  }

  requirements \
    curl \
    git \
    vim \
    zsh

  install

}

# Check requirements are satisfied.
function requirements() {
  for cmd in "$@"; do
    command -v "$cmd" >/dev/null 2>&1 || {
      echo >&2 "I require $cmd but it's not installed. Aborting."
      exit 1
    }
  done
}

main "$@"