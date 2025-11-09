-- Plugins specification
-- Add plugins here one at a time, test each before adding the next

local all = {}
vim.list_extend(all, require("plugins.colorscheme"))
vim.list_extend(all, require("plugins.telescope"))
vim.list_extend(all, require("plugins.autosave"))
vim.list_extend(all, require("plugins.treesitter"))
vim.list_extend(all, require("plugins.mason"))
vim.list_extend(all, require("plugins.lspconfig"))
vim.list_extend(all, require("plugins.cmp"))
return all
