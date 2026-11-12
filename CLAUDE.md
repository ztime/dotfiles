# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Core Principles

### 1. Small Incremental Changes, Tested
**Dotfiles break easily.** Always make the smallest possible change and test it before proceeding. Never bundle multiple changes together.

**Workflow:**
- Make ONE change at a time
- Test it yourself automatically wherever possible (see Principle 3)
- If part of it can only be verified by the user, tell them exactly what to check and **WAIT for confirmation**
- If something breaks, it's easy to identify what caused it

**Examples:**
- ✅ Add one alias → `zsh -ic 'type myalias'` → next change
- ✅ Install one plugin → headless `Lazy! sync` + check for errors → next change
- ✅ Change one keybinding → verify it loads, ask user to try the feel → wait → next change
- ❌ Add multiple aliases + plugins + keybindings all at once

### 2. Keep It Simple
Resist the urge to over-engineer. Simple, working configurations are better than complex, feature-rich ones that break.

**Guidelines:**
- Don't add unnecessary plugins or dependencies
- Don't create complex abstractions or file structures
- Don't add features "just in case" - only add what's actually needed
- Flat is better than nested when organizing config files

### 3. Test After Every Change
Run checks yourself, e.g.:
- **Zsh:** `zsh -n ~/.zshrc`, `zsh -ic exit` (no errors), `zsh -ic 'type <alias>'`
- **Shell scripts:** `bash -n`, then run them
- **Tmux:** `tmux source-file ~/.tmux.conf` (no errors), `tmux show -g <option>`
- **Neovim:** `nvim --headless "+Lazy! sync" +qa`, `nvim --headless +checkhealth`, or `nvim --headless -c 'lua ...' +qa` to assert a setting/keymap
- **Stow:** `stow --restow --target="$HOME" home`, then `ls -la` the targets
- **systemd:** `systemctl --user daemon-reload`, `start`, `status`, `journalctl --user -u <unit>`

Only what can't be checked automatically (visual look, interactive feel, GUI behaviour) goes to the user: say exactly what to test and **wait for confirmation**.

**Never disrupt the live desktop:** don't lock the screen, kill sessions, or restart the user's running tmux/herdr/terminal.

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
2. Verify with `zsh -ic 'type <alias>'`
3. Only then proceed to next change

### Adding a Neovim Plugin
1. Create/edit ONE plugin file in `lua/plugins/`
2. Add plugin spec (return a table following lazy.nvim format)
3. Add module to `lua/plugins/init.lua` via `vim.list_extend()`
4. Run `nvim --headless "+Lazy! sync" +qa` and check for errors
5. Only then proceed to next change

**Never add multiple plugins at once** - if something breaks, you won't know which plugin caused it.

### Adding a Tmux Plugin
1. Add ONE plugin line: `set -g @plugin 'author/name'`
2. Run `~/.tmux/plugins/tpm/bin/install_plugins` and `tmux source-file ~/.tmux.conf`
3. Only then proceed to next change

### Stow Safety
- Stow refuses to create symlinks if target files exist (backup first)
- Use `stow --delete` before removing files from `home/` to avoid broken symlinks
- Verify symlinks with `ls -la` after stowing

## Troubleshooting Approach

When something breaks:
1. **Revert the last change** - don't try to fix forward
2. Test that reverting fixes it
3. Understand why it broke
4. Make a smaller, simpler change
5. Test again

Configuration issues compound quickly. It's faster to revert and try again than to debug a broken system with multiple recent changes.

## Common Pitfalls

- Adding too many plugins at once → Can't identify which one broke things
- Complex nested file structures → Harder to understand and debug
- Not testing after each change → Multiple issues compound
- Over-engineering for future needs → Adds complexity with no immediate benefit
- Forgetting to run plugin managers → Changes don't take effect
- Skipping manual checks the user must do → Visual/interactive breakage goes unnoticed
