return {
  {
    "mfussenegger/nvim-dap",
    -- .vscode/launch.json is picked up automatically by dap.continue()
    dependencies = { "mfussenegger/nvim-dap-python" },
    config = function()
      -- uv fetches debugpy on demand, no install step needed
      require("dap-python").setup("uv")

      -- js-debug installed via :MasonInstall js-debug-adapter
      local js = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = vim.fn.stdpath("data") .. "/mason/bin/js-debug-adapter",
          args = { "${port}" },
        },
        -- js-debug only understands pwa-node; VS Code's launch.json often says "node"
        enrich_config = function(config, on_config)
          on_config(vim.tbl_extend("force", config, { type = "pwa-node" }))
        end,
      }
      local dap = require("dap")
      dap.adapters["pwa-node"] = js
      dap.adapters.node = js

      -- load dap-view now so its auto_toggle listeners exist before the first session
      require("dap-view")
    end,
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "Debug: continue" },
      { "<F10>", function() require("dap").step_over() end, desc = "Debug: step over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Debug: step into" },
      { "<F12>", function() require("dap").step_out() end, desc = "Debug: step out" },
      { "<leader>b", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
    },
  },
  {
    "igorlfs/nvim-dap-view",
    dependencies = { "mfussenegger/nvim-dap" },
    cmd = "DapViewToggle",
    keys = {
      { "<leader>v", "<cmd>DapViewToggle<cr>", desc = "Toggle debug view" },
    },
    -- auto-open the view on debug start, showing program output (repl tab) first
    opts = {
      auto_toggle = true,
      winbar = { default_section = "repl" },
    },
  },
}
