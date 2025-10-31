-- nvim-tree configuration
require("nvim-tree").setup({
  view = {
    width = 30,
  },
  renderer = {
    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
      },
    },
  },
  filters = {
    dotfiles = false,
  },
})
