#!/usr/bin/env bash
set -e

# Clone or update neovim configuration
if [ -d "$HOME/.config/nvim" ] && [ "$(ls -A "$HOME/.config/nvim")" ]; then
  pushd "$HOME/.config/nvim" && git pull
  popd
else
  git clone https://github.com/nvim-lua/kickstart.nvim.git ~/.config/nvim 
fi
