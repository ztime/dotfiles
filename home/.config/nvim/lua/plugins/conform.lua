return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      {
        "<leader>c",
        function()
          local conform = require("conform")
          -- Toggle auto-format on save
          if vim.g.conform_auto_format == nil then
            vim.g.conform_auto_format = true
          end
          vim.g.conform_auto_format = not vim.g.conform_auto_format
          local status = vim.g.conform_auto_format and "enabled" or "disabled"
          print("Auto-format " .. status)
        end,
        desc = "Toggle auto-format on save",
      },
      {
        "<leader>cf",
        function()
          require("conform").format({ async = false, lsp_fallback = true })
        end,
        desc = "Format buffer",
      },
    },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          python = { "black" },
          javascript = { "prettier" },
          typescript = { "prettier" },
          json = { "prettier" },
          lua = { "stylua" },
          rust = { "rustfmt" },
          sh = { "shfmt" },
        },
        format_on_save = function(bufnr)
          if vim.g.conform_auto_format then
            return { timeout_ms = 500, lsp_fallback = true }
          end
        end,
      })
      -- Default to enabled
      vim.g.conform_auto_format = true
    end,
  },
}
