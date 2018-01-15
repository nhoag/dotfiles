# Dotfiles

My personal dotfiles.

## Requirements

* cURL
* Git
* Vim
* zsh

## Install

```bash
cd
git clone --separate-git-dir=$HOME/.dotfiles git@github.com:nhoag/dotfiles.git $(mktemp -d)
alias dots='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dots config status.showUntrackedFiles no
dots checkout .
chsh -s $(which zsh)
zsh
```

## Update

```bash
cd && dots pull
```

