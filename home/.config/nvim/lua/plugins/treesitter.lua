return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install({
        "lua",
        "vim",
        "python",
        "typescript",
        "javascript",
        "dockerfile",
        "bash",
        "rust",
        "java",
        "markdown",
        "markdown_inline",
      })
      -- Highlight any filetype that has a parser installed
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },
}
