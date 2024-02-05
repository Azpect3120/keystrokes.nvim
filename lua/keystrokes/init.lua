-- Imports the plugin's additional Lua modules.
-- local fetch = require("keystrokes.fetch")
-- local update = require("keystrokes.update")

-- Creates an object for the module. All of the module's
-- functions are associated with this object, which is
-- returned when the module is called with `require`.
local M = {}

function Handler (key)
end

local config = {
  win_opts = {
  },
  enable_on_startup = false
}

local function createWindow ()
  buf = vim.api.nvim_create_buf(false, true)
  win = vim.api.nvim_open_win(buf, false, {
    relative="editor",
    style="minimal",
    border="shadow",
    row=vim.o.lines,
    col=vim.o.columns,
    width=25,
    height=25,
  })
  vim.api.nvim_buf_set_option(buf, "filetype", "keys")
end

function M.test ()
  -- vim.cmd([[autocmd CursorMoved,CursorMovedI * lua Handler(vim.fn.nr2char(vim.fn.getchar()))]])
  createWindow()
end

return M
