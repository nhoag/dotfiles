if [[ -n "$ZSH_VERSION" ]]; then
  if [[ -f "$HOME/.zshrc" ]]; then
    # shellcheck disable=SC1090
    . "$HOME/.zshrc"
  fi
fi

