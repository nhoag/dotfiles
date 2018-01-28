# Dotfiles

[![Build Status](https://travis-ci.org/nhoag/dotfiles.svg?branch=master)](https://travis-ci.org/nhoag/dotfiles)

My personal dotfiles!

## Requirements

* cURL
* Git
* Vim
* zsh

## Install

**WARNING:** The installer script will destroy contents in the home directory. It's recommended to back up valuable home directory contents before proceeding.

```bash
curl -sO https://raw.githubusercontent.com/nhoag/dotfiles/master/installer.sh
# Visually inspect the file, then:
chmod +x ./installer.sh
./installer.sh
```

### macOS

Install [Homebrew](https://brew.sh/) and install packages via [Homebrew Bundle](https://github.com/Homebrew/homebrew-bundle) with `brew bundle`.

## Update

```bash
dots pull
```

## Usage

After running the installer script, the home directory becomes a bare Git repository with the `git` command aliased to `dots` for convenience (or you can use the full invocation `git --git-dir="$HOME/.dotfiles" --work-tree="$HOME"`). Any updates can be processed via Git, though be careful not to commit sensitive files!
