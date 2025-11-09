-- Ultimate Neovim Setup
-- Stability and Portability First

-- Set <space> as leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Core settings
local opt = vim.opt
opt.number = true           -- Line numbers
opt.relativenumber = true   -- Relative line numbers
opt.mouse = "a"             -- Enable mouse
opt.clipboard = "unnamedplus" -- Use system clipboard
opt.undofile = true         -- Persistent undo
opt.ignorecase = true       -- Ignore case in search
opt.smartcase = true        -- But be smart about it
opt.expandtab = true        -- Use spaces instead of tabs
opt.shiftwidth = 2          -- Indent width
opt.tabstop = 2             -- Tab width
opt.autoindent = true       -- Auto indent
opt.wrap = false            -- Don't wrap long lines
opt.termguicolors = true    -- True color support
opt.swapfile = false        -- Disable swap files

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim with minimal plugins
require("lazy").setup({
  -- We'll add plugins here one at a time
  spec = "plugins",
}, {
  defaults = { lazy = true },
  install = { colorscheme = { "default" } },
  checker = { enabled = false },
  change_detection = { enabled = false },
})

-- Basic keybindings
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Escape key
keymap("i", "jk", "<ESC>", opts)

print("Neovim setup loaded successfully")
