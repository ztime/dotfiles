# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Core Principles

### 1. Small Incremental Changes with User Testing
**Dotfiles break easily.** Always make the smallest possible change and wait for the user to test it before proceeding. Never bundle multiple changes together.

**Workflow:**
- Make ONE change at a time
- Ask user to test it (source the config, restart the shell, reopen nvim, etc.)
- **WAIT for user confirmation** before making the next change
- Only the user can test - don't attempt to run tests yourself
- If something breaks, it's easy to identify what caused it

**Examples:**
- ✅ Add one alias → user tests → wait for confirmation → next change
- ✅ Install one plugin → user tests → wait for confirmation → next change
- ✅ Change one keybinding → user tests → wait for confirmation → next change
- ❌ Add multiple aliases + plugins + keybindings all at once

### 2. Keep It Simple
Resist the urge to over-engineer. Simple, working configurations are better than complex, feature-rich ones that break.

**Guidelines:**
- Don't add unnecessary plugins or dependencies
- Don't create complex abstractions or file structures
- Don't add features "just in case" - only add what's actually needed
- Flat is better than nested when organizing config files

### 3. User Testing After Every Change
After any change, tell the user how to test it:
- **Zsh changes:** User runs `source ~/.zshrc` or restarts shell
- **Tmux changes:** User runs `tmux source ~/.tmux.conf` or `prefix + R`
- **Neovim changes:** User restarts nvim, runs `:Lazy sync` if needed
- **Stow changes:** User verifies symlinks with `ls -la`

**Wait for user confirmation that it works before proceeding.**

## Repository Overview

Personal dotfiles managed with GNU Stow for:
- Zsh (with Zinit, Powerlevel10k)
- Neovim (with lazy.nvim)
- Tmux (with TPM)
- Alacritty terminal

## Key Commands

### Initial Setup
```bash
./setup.sh
```

### Stow Operations
```bash
stow --target="$HOME" home           # Create symlinks
stow --delete --target="$HOME" home  # Remove symlinks
stow --restow --target="$HOME" home  # Update after changes
```

### Neovim Plugin Management
```bash
nvim --headless "+Lazy! sync" +qa    # Sync all plugins
# Or inside nvim: :Lazy sync
```

### Tmux Plugin Management
```bash
~/.tmux/plugins/tpm/bin/install_plugins
# Or inside tmux: prefix + I
```

## Architecture

### Stow Structure
The `home/` directory mirrors `$HOME` structure. Running `stow --target="$HOME" home` creates symlinks:
- `home/.zshrc` → `~/.zshrc`
- `home/.config/nvim/init.lua` → `~/.config/nvim/init.lua`

**Important:** Editing symlinked files in `$HOME` directly modifies the git-tracked originals.

### Configuration Entry Points
- **Zsh:** `home/.zshrc` (sources `.zshrc.local` for machine-specific overrides)
- **Neovim:** `home/.config/nvim/init.lua` (loads plugins from `lua/plugins/`)
- **Tmux:** `home/.tmux.conf`
- **Alacritty:** `home/.config/alacritty/alacritty.toml`

### Neovim Plugin System
Plugins are modularized in `lua/plugins/` directory. Each file returns a table (or array of tables) with plugin specs. The `lua/plugins/init.lua` file combines all plugin modules using `vim.list_extend()`.

**LSP servers** are auto-installed via Mason when defined in `lua/plugins/lspconfig.lua`.

### Local Machine Overrides
`.zshrc.local` allows machine-specific configuration without affecting version control. The file is tracked as empty but changes are ignored by git.

## Making Changes Safely

### Adding a Zsh Alias
1. Add ONE alias to `.zshrc`
2. Tell user to run `source ~/.zshrc`
3. **Wait for user to confirm it works**
4. Only then proceed to next change

### Adding a Neovim Plugin
1. Create/edit ONE plugin file in `lua/plugins/`
2. Add plugin spec (return a table following lazy.nvim format)
3. Add module to `lua/plugins/init.lua` via `vim.list_extend()`
4. Tell user to run `:Lazy sync` in nvim
5. **Wait for user to confirm it works**
6. Only then proceed to next change

**Never add multiple plugins at once** - if something breaks, you won't know which plugin caused it.

### Adding a Tmux Plugin
1. Add ONE plugin line: `set -g @plugin 'author/name'`
2. Tell user to reload: `prefix + R` and install: `prefix + I`
3. **Wait for user to confirm it works**
4. Only then proceed to next change

### Stow Safety
- Stow refuses to create symlinks if target files exist (backup first)
- Use `stow --delete` before removing files from `home/` to avoid broken symlinks
- User should verify symlinks with `ls -la` after stowing

## Troubleshooting Approach

When something breaks:
1. **Revert the last change** - don't try to fix forward
2. User tests that reverting fixes it
3. Understand why it broke
4. Make a smaller, simpler change
5. User tests again

Configuration issues compound quickly. It's faster to revert and try again than to debug a broken system with multiple recent changes.

## Common Pitfalls

- Adding too many plugins at once → Can't identify which one broke things
- Complex nested file structures → Harder to understand and debug
- Not waiting for user testing after each change → Multiple issues compound
- Over-engineering for future needs → Adds complexity with no immediate benefit
- Forgetting to tell user to run plugin managers → Changes don't take effect
- Trying to test changes yourself → Only user can test in their environment
