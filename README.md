# Dotfiles

[![Build Status](https://travis-ci.org/nhoag/dotfiles.svg?branch=master)](https://travis-ci.org/nhoag/dotfiles)

My personal dotfiles!

## Requirements

* cURL
* Git
* Vim
* zsh

## Install

By default, the installer script will not overwrite contents in the home directory. If you're sure this is what you want, run the installer with `--force`.

```bash
curl -sO https://raw.githubusercontent.com/nhoag/dotfiles/master/installer.sh
echo "47f50d25850121335291a88782d532c665f28348d986fa1592b6f89b314b6b42  installer.sh" |
  shasum -c
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
