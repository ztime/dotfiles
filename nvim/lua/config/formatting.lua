-- conform.nvim formatter configuration
local conform = require("conform")

conform.setup({
  formatters_by_ft = {
    python = { "black" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    vue = { "prettier" },
    json = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
    dockerfile = { "prettier" },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
})

-- Keybinding for manual formatting
vim.keymap.set("n", "<leader>f", function()
  conform.format({ async = true, lsp_fallback = true })
end, { noremap = true, silent = true })
