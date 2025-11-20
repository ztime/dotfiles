return {
  {
    "numToStr/Comment.nvim",
    keys = {
      { "gcc", desc = "Toggle comment line" },
      { "gc", mode = "v", desc = "Toggle comment selection" },
    },
    config = function()
      require("Comment").setup({})
    end,
  },
}
