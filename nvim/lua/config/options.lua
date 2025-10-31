-- Basic Neovim options
local opt = vim.opt

-- Indentation
opt.expandtab = true
opt.shiftwidth = 2
opt.softtabstop = 2
opt.tabstop = 2

-- Display
opt.number = true
opt.relativenumber = true
opt.wrap = true
opt.linebreak = true
opt.cursorline = true
opt.signcolumn = "yes"

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false

-- Behavior
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.undofile = true
opt.backup = false
opt.swapfile = false

-- Split behavior
opt.splitbelow = true
opt.splitright = true

-- Appearance
opt.termguicolors = true
