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
        pyright = {
          -- Use the nearest .venv (uv, or poetry with in-project venvs), searching
          -- upward since the LSP root can be a subdirectory of the project
          before_init = function(_, config)
            local venv = vim.fs.find(".venv", {
              path = config.root_dir,
              upward = true,
              type = "directory",
              stop = vim.env.HOME,
            })[1]
            if venv and vim.uv.fs_stat(venv .. "/bin/python") then
              config.settings.python.pythonPath = venv .. "/bin/python"
            end
          end,
        },
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
      for server, config in pairs(servers) do
        vim.lsp.config(server, config)
      end

      vim.lsp.enable(vim.tbl_keys(servers))
    end,
  },
}
