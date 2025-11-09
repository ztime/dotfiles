return {
  {
    "okuuva/auto-save.nvim",
    event = { "InsertLeave", "TextChanged" },
    config = function()
      require("auto-save").setup({
        trigger_events = {
          immediate_write = { "BufLeave", "FocusLost" },
          defer_write = { "InsertLeave", "TextChanged" },
        },
        debounce_delay = 1000, -- Save 1 second after last change
        write_all_buffers = false,
      })
    end,
  },
}
