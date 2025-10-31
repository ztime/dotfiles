-- Lualine (statusline) configuration
require("lualine").setup({
  options = {
    theme = "sonokai",
    section_separators = { left = "", right = "" },
    component_separators = { left = "|", right = "|" },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff" },
    lualine_c = { "filename" },
    lualine_x = { "diagnostics", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
})
