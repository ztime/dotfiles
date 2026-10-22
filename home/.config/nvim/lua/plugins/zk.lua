-- Zettelkasten notes via the zk CLI (https://github.com/zk-org/zk)
-- Notebook: ~/git_strawberry/notes

-- Fallback notebook for zk commands run outside the notes folder
vim.env.ZK_NOTEBOOK_DIR = vim.fn.expand("~/git_strawberry/notes")

local function new_note(dir)
  return function()
    local title = vim.fn.input("Title: ")
    if title ~= "" then
      require("zk.commands").get("ZkNew")({ dir = dir, title = title })
    end
  end
end

-- Silverbullet-style links: <CR> on [[Some title]] follows the link if the note
-- exists, otherwise creates it in zettel/ and rewrites the link to point at it.
local function follow_or_create()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1
  local s, e, inner
  local init = 1
  while true do
    s, e, inner = line:find("%[%[(.-)%]%]", init)
    if not s or s > col then
      return vim.lsp.buf.definition()
    end
    if col <= e then
      break
    end
    init = e + 1
  end

  local client = vim.lsp.get_clients({ bufnr = 0, name = "zk" })[1]
  if client then
    local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
    local res = client:request_sync("textDocument/definition", params, 2000, 0)
    if res and res.result and not vim.tbl_isempty(res.result) then
      return vim.lsp.buf.definition()
    end
  end

  local title = vim.trim(inner:match("|(.*)$") or inner)
  if title == "" then
    return
  end
  local row = vim.api.nvim_win_get_cursor(0)[1] - 1
  require("zk").new({
    dir = "zettel",
    title = title,
    insertLinkAtLocation = {
      uri = vim.uri_from_bufnr(0),
      range = {
        start = { line = row, character = vim.str_utfindex(line, "utf-16", s - 1) },
        ["end"] = { line = row, character = vim.str_utfindex(line, "utf-16", e) },
      },
    },
  })
end

return {
  {
    "zk-org/zk-nvim",
    name = "zk",
    ft = "markdown",
    cmd = { "ZkNew", "ZkNotes", "ZkTags", "ZkBacklinks", "ZkLinks", "ZkInsertLink" },
    dependencies = { "nvim-telescope/telescope.nvim" },
    keys = {
      { "<leader>zn", new_note("zettel"), desc = "Zk: new permanent note" },
      { "<leader>zf", new_note("fleeting"), desc = "Zk: new fleeting note" },
      { "<leader>zl", new_note("literature"), desc = "Zk: new literature note" },
      { "<leader>zo", "<cmd>ZkNotes { sort = { 'modified' } }<cr>", desc = "Zk: open notes" },
      { "<leader>zt", "<cmd>ZkTags<cr>", desc = "Zk: browse tags" },
      { "<leader>zi", "<cmd>ZkNotes { hrefs = { 'fleeting' }, sort = { 'created' } }<cr>", desc = "Zk: fleeting inbox" },
      {
        "<leader>zs",
        "<cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<cr>",
        desc = "Zk: search notes",
      },
      { "<leader>zn", ":'<,'>ZkNewFromTitleSelection { dir = 'zettel' }<cr>", mode = "v", desc = "Zk: new note from selection" },
    },
    config = function()
      require("zk").setup({
        picker = "telescope",
        lsp = {
          config = {
            name = "zk",
            -- Full path: GUI-launched nvim doesn't get ~/.local/bin on PATH
            cmd = { vim.fn.expand("~/.local/bin/zk"), "lsp" },
            filetypes = { "markdown" },
          },
          auto_attach = { enabled = true },
        },
      })

      -- Buffer-local mappings, only inside a zk notebook
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function(args)
          if require("zk.util").notebook_root(vim.fn.expand("%:p")) == nil then
            return
          end
          local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = args.buf, silent = true, desc = desc })
          end
          map("n", "<CR>", follow_or_create, "Zk: follow link or create note")
          map("n", "<leader>zb", "<cmd>ZkBacklinks<cr>", "Zk: backlinks")
          map("n", "<leader>zL", "<cmd>ZkLinks<cr>", "Zk: outgoing links")
          map("n", "<leader>zk", "<cmd>ZkInsertLink<cr>", "Zk: insert link")
          map("v", "<leader>zk", ":'<,'>ZkInsertLinkAtSelection<cr>", "Zk: link selection")
          map("n", "K", vim.lsp.buf.hover, "Zk: preview linked note")
        end,
      })
    end,
  },
}
