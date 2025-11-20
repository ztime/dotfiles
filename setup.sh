#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Install stow if not already installed
if ! command -v stow &> /dev/null; then
    echo "Installing stow..."
    if command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y stow
    elif command -v yum &> /dev/null; then
        sudo yum install -y stow
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm stow
    elif command -v brew &> /dev/null; then
        brew install stow
    else
        echo "Error: Could not find package manager. Please install stow manually."
        exit 1
    fi
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
