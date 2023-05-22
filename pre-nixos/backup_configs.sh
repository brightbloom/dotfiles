#!/usr/bin/env bash

DOTFILES=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )


rm -rf ${DOTFILES}/config

# Program configs
mkdir -p ${DOTFILES}/config
cp -r ~/.config/tmux/ \
      ~/.config/kitty/ \
      ~/.config/nvim/ \
      ~/.config/wezterm/ \
      ~/.config/waybar/ \
      ~/.config/sway/ \
      ~/.config/hypr/ \
      ~/.config/powerlevel10k/ \
      ~/.config/lazygit/ \
      ${DOTFILES}/config/

cp /etc/systemd/user/neovim_server.service ${DOTFILES}/neovim_server.service

# Themes
mkdir -p ${DOTFILES}/themes
rsync -rq --exclude=.git ~/.themes/* ${DOTFILES}/themes

# ZSH config doesn't live inside XDG scheme
cp ~/.zshrc ${DOTFILES}/zshrc
