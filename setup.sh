#!/usr/bin/env bash

# Enable strict mode in CI or when explicitly requested
if [ "$STRICT_MODE" = "true" ] || [ "$CI" = "true" ]; then
  set -e
  BASH_FLAGS="-e"
else
  BASH_FLAGS=""
fi

script_dir=$(dirname "$(readlink -f "$0")")

bash $BASH_FLAGS "$script_dir/setup/core/system-deps.sh"

# Ensure bun is on PATH for subsequent scripts
export PATH="$HOME/.bun/bin:$PATH"

bash $BASH_FLAGS "$script_dir/setup/core/homebrew.sh"

# Ensure homebrew is on PATH for subsequent scripts
if [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Check for node and npm before installing fnm
if ! command -v node &>/dev/null || ! command -v npm &>/dev/null; then
  # Install fnm if not present
  if ! command -v fnm &>/dev/null; then
    curl -fsSL https://fnm.vercel.app/install | bash
    export PATH="$HOME/.local/share/fnm:$PATH"
  fi

  # Ensure fnm is initialized for this script
  export PATH="$HOME/.local/share/fnm:$PATH"
  eval "$(fnm env --shell bash)"

  # Install latest LTS node and set as default
  fnm install 24
  fnm default 24
fi

# Ensure fnm-managed node is on PATH for subsequent scripts
if command -v fnm &>/dev/null; then
  eval "$(fnm env --shell bash)"
fi

# Install global npm tools
bash $BASH_FLAGS "$script_dir/setup/core/npm-tools.sh"

# Ensure npm global bin is on PATH for subsequent scripts
export PATH="$HOME/.npm-global/bin:$PATH"

bash $BASH_FLAGS "$script_dir/setup/shells/setup-bash.sh"
bash $BASH_FLAGS "$script_dir/setup/shells/setup-zsh.sh"
bash $BASH_FLAGS "$script_dir/setup/shells/setup-fish.sh"

# Install linter.sh to ~/.local/bin/lint
mkdir -p "$HOME/.local/bin"
cp "$script_dir/linter.sh" "$HOME/.local/bin/lint"
chmod +x "$HOME/.local/bin/lint"

# Install auth.sh to ~/.local/bin/auth
cp "$script_dir/auth.sh" "$HOME/.local/bin/auth"
chmod +x "$HOME/.local/bin/auth"

# Install bohemia.sh to ~/.local/bin/bohemia
cp "$script_dir/bohemia.sh" "$HOME/.local/bin/bohemia"
chmod +x "$HOME/.local/bin/bohemia"

bash $BASH_FLAGS "$script_dir/setup/setup-editors.sh"
bash $BASH_FLAGS "$script_dir/setup/setup-terminal.sh"
bash $BASH_FLAGS "$script_dir/setup/setup-ai.sh"
bash $BASH_FLAGS "$script_dir/setup/setup-shims.sh"
