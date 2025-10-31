-- LSP Configuration
local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

-- Common LSP capabilities (from nvim-cmp)
local capabilities = cmp_nvim_lsp.default_capabilities()

-- LSP keymaps for when LSP attaches to a buffer
local function on_attach(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

  -- Register LSP keybindings with which-key (already added in which-key.lua)
end

-- Pyright (Python type checker)
lspconfig.pyright.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",
      },
    },
  },
})

-- Ruff (Python linter)
lspconfig.ruff_lsp.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

-- Lua LSP (for your config files)
lspconfig.lua_ls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
    },
  },
})

-- TypeScript/JavaScript LSP
lspconfig.tsserver.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = { "javascript", "typescript", "typescriptreact" },
})

-- Vue LSP (Volar)
lspconfig.volar.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = { "vue" },
  init_options = {
    vue = {
      hybridMode = false,
    },
  },
})
