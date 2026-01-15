return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua",
          "vim",
          "python",
          "typescript",
          "javascript",
          "dockerfile",
          "bash",
          "rust",
          "java",
        },
        highlight = {
          enable = true,
        },
      })
    end,
  },
}
