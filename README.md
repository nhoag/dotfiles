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
git clone --separate-git-dir=$HOME/.dotfiles git@github.com:nhoag/dotfiles.git $HOME/dotfiles-tmp
rm -r $HOME/dotfiles-tmp
alias dots='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dots checkout .
chsh -s $(which zsh)
```

## Update

```bash
cd && dots pull
```

