# Dotfiles

My dotfiles!

## Quick Setup

```bash
git clone https://github.com/yourusername/dotfiles.git
cd dotfiles
./setup.sh
```

The setup script will:
- Install GNU Stow (if not present)
- Create symlinks from the `home/` directory to your home directory
- Install tmux and Neovim plugins

## Local Overrides

Edit `.zshrc.local` for machine-specific shell configuration. This file is not tracked by Git.
