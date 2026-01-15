return {
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "Trouble",
    keys = {
      { "<leader>d", "<cmd>Trouble diagnostics toggle<cr>", desc = "Toggle diagnostics" },
    },
    config = function()
      require("trouble").setup({
        focus = true,
      })
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
  },
}
