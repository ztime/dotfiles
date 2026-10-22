#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Install packages for the detected OS
if [[ "$OSTYPE" == darwin* ]]; then
    echo "Detected macOS"
    if ! command -v brew &> /dev/null; then
        echo "Error: Homebrew not found. Install it from https://brew.sh first."
        exit 1
    fi
    brew install git zsh tmux neovim stow fzf ripgrep fd tree-sitter-cli
elif command -v pacman &> /dev/null; then
    echo "Detected Arch/Manjaro"
    sudo pacman -S --needed --noconfirm git zsh tmux neovim stow fzf ripgrep fd tree-sitter-cli base-devel unzip curl
elif command -v apt-get &> /dev/null; then
    echo "Detected Debian/Ubuntu"
    sudo apt-get update
    # neovim and tree-sitter-cli in apt are too old/missing, handled separately
    sudo apt-get install -y git zsh tmux stow fzf ripgrep fd-find build-essential unzip curl
else
    echo "Error: Unsupported OS. Install packages manually."
    exit 1
fi

# Create symlinks using stow
echo "Creating symlinks with stow..."
cd "$SCRIPT_DIR"
stow --target="$HOME" home

# Setup tmux plugins
echo "Setting up tmux plugins..."
if [ ! -d ~/.tmux/plugins/tpm ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    echo "Installing tpm plugin dependencies..."
    ~/.tmux/plugins/tpm/bin/install_plugins
else
    echo "tmux plugin manager already installed"
fi

# Setup nvim plugins
echo "Setting up nvim plugins..."
if command -v nvim &> /dev/null; then
    nvim --headless "+Lazy! sync" +qa
else
    echo "nvim not installed, skipping plugin setup"
fi

echo "Setup complete!"
