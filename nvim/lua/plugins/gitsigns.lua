return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      { "<leader>gb", "<cmd>Gitsigns blame_line<cr>", desc = "Git blame current line" },
      { "<leader>gd", "<cmd>Gitsigns diffthis<cr>", desc = "Git diff current file" },
      { "<leader>gh", "<cmd>Gitsigns preview_hunk<cr>", desc = "Git preview hunk" },
    },
    config = function()
      require("gitsigns").setup({
        current_line_blame = false,
      })
    end,
  },
}
