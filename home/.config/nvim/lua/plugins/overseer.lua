return {
  {
    "stevearc/overseer.nvim",
    -- .vscode/tasks.json is picked up automatically
    cmd = { "OverseerRun", "OverseerToggle" },
    keys = {
      { "<leader>tr", "<cmd>OverseerRun<cr>", desc = "Run task" },
      { "<leader>tt", "<cmd>OverseerToggle<cr>", desc = "Toggle task list" },
    },
    opts = {},
  },
}
