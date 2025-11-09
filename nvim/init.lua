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

-- Show full diagnostic message
keymap("n", "<leader>k", vim.diagnostic.open_float, { noremap = true, silent = true, desc = "Show diagnostic message" })

-- LSP keybindings
keymap("n", "gd", vim.lsp.buf.definition, { noremap = true, silent = true, desc = "Go to definition" })
keymap("n", "gD", vim.lsp.buf.declaration, { noremap = true, silent = true, desc = "Go to declaration" })
keymap("n", "gi", vim.lsp.buf.implementation, { noremap = true, silent = true, desc = "Go to implementation" })
keymap("n", "gr", vim.lsp.buf.references, { noremap = true, silent = true, desc = "Show references" })
keymap("n", "<leader>rn", vim.lsp.buf.rename, { noremap = true, silent = true, desc = "Rename symbol" })
keymap("n", "<leader>a", vim.lsp.buf.code_action, { noremap = true, silent = true, desc = "Code actions" })

-- Diagnostics (inline virtual text)
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
})

print("Neovim setup loaded successfully")
