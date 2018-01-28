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

  if [[ -d "$HOME/$DOTS_DIR" ]]; then
    echo 'Already installed.'
  else
    # Use https for CI.
    if [[ -z "$CI" ]]; then
      REPO_PREFIX='git@github.com:'
    else
      REPO_PREFIX='https://github.com/'
    fi

    # Clone to a throw-away location.
    git clone \
      --recursive \
      --separate-git-dir="$HOME/$DOTS_DIR" \
      "$REPO_PREFIX"nhoag/dotfiles.git \
      "$(mktemp -d)"
  fi

  dots config status.showUntrackedFiles no

  # Require 'force' to overwrite the home directory.
  if [[ "$FORCE" == true ]]; then
    dots checkout .
  else
    echo 'Dotfiles installed but not checked out.'
    echo 'Review pending changes with:'
    # shellcheck disable=SC2016
    echo '  git --git-dir="$HOME/'"$DOTS_DIR"'" --work-tree="$HOME" diff'
  fi

  [[ -z "$CI" ]] && {
    # Switch the default shell to zsh (requires sudo) - no effect until login.
    # Disable for CI.
    chsh -s "$(which zsh)"

    # Use zsh right now (and trigger zgen build).
    zsh
  }

  cd -

}

# Main installer function.
function main() {

  POSITIONAL=()
  while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
      -f|--force)
        FORCE=true
        shift
        ;;
      *)
        POSITIONAL+=("$1")
        shift
        ;;
    esac
  done
  set -- "${POSITIONAL[@]}"

  local DOTS_DIR=${1:-'.dotfiles'}

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
