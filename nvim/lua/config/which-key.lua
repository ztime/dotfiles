-- which-key.nvim configuration
local wk = require("which-key")

wk.setup({
  preset = "helix",
  delay = 200,
  icons = {
    breadcrumb = "»",
    separator = "➜",
    group = "+",
  },
})

-- Register keybinding specs with descriptions
wk.add({
  -- Telescope/Find
  { "<leader>f", group = "find" },
  { "<leader>ff", desc = "Find files" },
  { "<leader>fg", desc = "Live grep" },
  { "<leader>fb", desc = "Buffers" },
  { "<leader>fh", desc = "Help tags" },

  -- Git
  { "<leader>g", group = "git" },
  { "<leader>gs", desc = "Status" },
  { "<leader>ga", desc = "Add all" },
  { "<leader>gc", desc = "Commit" },
  { "<leader>gp", desc = "Push" },

  -- Buffers
  { "<leader>b", group = "buffer" },
  { "<leader>bn", desc = "Next" },
  { "<leader>bp", desc = "Previous" },
  { "<leader>bd", desc = "Delete" },

  -- Code/LSP
  { "<leader>c", group = "code" },
  { "<leader>ca", desc = "Code action" },

  -- Refactor
  { "<leader>r", group = "refactor" },
  { "<leader>rn", desc = "Rename" },

  -- Other
  { "<leader>e", desc = "Explorer (nvim-tree)" },
  { "<leader>h", desc = "Clear search highlight" },
  { "<leader>f", desc = "Format" },
})
