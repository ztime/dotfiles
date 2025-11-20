return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    keys = {
      {
        "s",
        mode = { "n", "o", "x" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
    },
    config = function()
      require("flash").setup({
        search = {
          forward = true,
          multi_window = true,
          incremental = true,
        },
        label = {
          uppercase = false,
          before = true,
          after = true,
        },
      })
    end,
  },
}
