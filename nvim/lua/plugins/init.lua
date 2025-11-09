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
vim.list_extend(all, require("plugins.trouble"))
vim.list_extend(all, require("plugins.whichkey"))
vim.list_extend(all, require("plugins.gitsigns"))
vim.list_extend(all, require("plugins.neotree"))
vim.list_extend(all, require("plugins.flash"))
vim.list_extend(all, require("plugins.autopairs"))
vim.list_extend(all, require("plugins.comment"))
vim.list_extend(all, require("plugins.conform"))
vim.list_extend(all, require("plugins.indent-blankline"))
return all
