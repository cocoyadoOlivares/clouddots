#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Clone or update neovim configuration
if [ -d "$HOME/.config/nvim" ] && [ "$(ls -A "$HOME/.config/nvim")" ]; then
  pushd "$HOME/.config/nvim" && git pull
  popd
else
  git clone https://github.com/nvim-lua/kickstart.nvim.git ~/.config/nvim
fi

# Enable custom plugins import in kickstart's init.lua
sed -i "s|-- { import = 'custom.plugins' }|{ import = 'custom.plugins' }|" "$HOME/.config/nvim/init.lua"

# Add TypeScript LSP (ts_ls) to the servers table if not already present
# typescript-language-server is installed globally via npm (npm-tools.sh)
grep -q 'ts_ls' "$HOME/.config/nvim/init.lua" || \
  sed -i 's/\([ \t]*\)lua_ls = {/\1ts_ls = {},\n\1lua_ls = {/' "$HOME/.config/nvim/init.lua"

# Deploy custom plugin specs (lazygit, diffview)
mkdir -p "$HOME/.config/nvim/lua/custom/plugins"
cp -r "$SCRIPT_DIR/nvim/lua/custom/plugins/." "$HOME/.config/nvim/lua/custom/plugins/"

# Deploy after/plugin overrides (clipboard, autoread, jj, Tab completion)
mkdir -p "$HOME/.config/nvim/after/plugin"
cp -r "$SCRIPT_DIR/nvim/after/plugin/." "$HOME/.config/nvim/after/plugin/"
