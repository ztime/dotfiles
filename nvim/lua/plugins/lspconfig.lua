return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      -- Setup language servers
      local servers = {
        lua_ls = {},
        pyright = {},
        ts_ls = {},
        dockerls = {},
        bashls = {},
        rust_analyzer = {},
      }

      -- Ensure Mason and mason-lspconfig are set up first
      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_keys(servers),
        automatic_installation = true,
      })

      -- Setup each server
      for server, _ in pairs(servers) do
        vim.lsp.config(server, {})
      end

      vim.lsp.enable(vim.tbl_keys(servers))
    end,
  },
}
