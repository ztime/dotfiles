-- lazy.nvim configuration
require("lazy").setup({
  spec = {
    -- Colorscheme (Sonokai)
    {
      "sainnhe/sonokai",
      lazy = false,
      priority = 1000,
      config = function()
        vim.cmd.colorscheme("sonokai")
      end,
    },

    -- Treesitter (syntax highlighting and more)
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      event = { "BufReadPre", "BufNewFile" },
      config = function()
        require("nvim-treesitter.configs").setup({
          ensure_installed = {
            "python",
            "lua",
            "bash",
            "json",
            "yaml",
            "vim",
            "javascript",
            "typescript",
            "vue",
            "dockerfile",
            "css",
            "html",
          },
          highlight = { enable = true },
          indent = { enable = true },
        })
      end,
    },

    -- LSP Configuration
    {
      "neovim/nvim-lspconfig",
      event = { "BufReadPre", "BufNewFile" },
      config = function()
        require("config.lsp")
      end,
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
      },
    },

    -- Completion
    {
      "hrsh7th/nvim-cmp",
      event = "InsertEnter",
      config = function()
        require("config.completion")
      end,
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
      },
    },

    -- Snippets
    {
      "L3MON4D3/LuaSnip",
      build = "make install_jsregexp",
    },

    -- Fuzzy finder
    {
      "nvim-telescope/telescope.nvim",
      cmd = "Telescope",
      config = function()
        require("config.telescope")
      end,
      dependencies = { "nvim-lua/plenary.nvim" },
    },

    -- Git integration
    {
      "tpope/vim-fugitive",
      cmd = { "Git", "G" },
    },
    {
      "lewis6991/gitsigns.nvim",
      event = { "BufReadPre", "BufNewFile" },
      config = function()
        require("gitsigns").setup()
      end,
    },

    -- Statusline
    {
      "nvim-lualine/lualine.nvim",
      event = "VeryLazy",
      config = function()
        require("config.lualine")
      end,
      dependencies = { "nvim-tree/nvim-web-devicons" },
    },

    -- File explorer
    {
      "nvim-tree/nvim-tree.lua",
      cmd = "NvimTreeToggle",
      config = function()
        require("config.nvim-tree")
      end,
      dependencies = { "nvim-tree/nvim-web-devicons" },
    },

    -- Comments
    {
      "numToStr/comment.nvim",
      event = { "BufReadPre", "BufNewFile" },
      config = function()
        require("comment").setup()
      end,
    },

    -- Docker syntax highlighting
    {
      "ekalinin/Dockerfile.vim",
      ft = "dockerfile",
    },

    -- Formatting (Prettier, Black, etc.)
    {
      "stevearc/conform.nvim",
      event = { "BufReadPre", "BufNewFile" },
      config = function()
        require("config.formatting")
      end,
    },

    -- Keybinding helper
    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      config = function()
        require("config.which-key")
      end,
    },
  },
  install = { colorscheme = { "sonokai" } },
})
