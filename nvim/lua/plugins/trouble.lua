return {
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "Trouble",
    keys = {
      { "<leader>e", "<cmd>Trouble diagnostics toggle<cr>", desc = "Toggle trouble panel" },
    },
    config = function()
      require("trouble").setup({})
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
  },
}
