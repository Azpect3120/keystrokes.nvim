-- Imports the plugin's additional Lua modules.
-- local fetch = require("keystrokes.fetch")
-- local update = require("keystrokes.update")

-- Creates an object for the module. All of the module's
-- functions are associated with this object, which is
-- returned when the module is called with `require`.
local M = {}

function Handler (key)
  print(key)
end

local function createWindow ()
  -- nvim_create_buf({listed}, {scratch}): buffer handler OR 0 on error
  local buf = vim.api.nvim_create_buf(false, true)

  -- nvim_open_win(){buffer}, {enter}, {*config}): window handler OR 0 on error
  vim.api.nvim_open_win(buf, false, {
    relative="editor",    -- creates float when specified
    style="minimal",      -- remove the normal vim setup
    border="rounded",     -- options: "single", "double", "shadow", "rounded", "none", "solid", or array of 8 characters. eg. [ "╔", "═" ,"╗", "║", "╝", "═", "╚", "║" ]
    row=vim.o.lines,      -- row position
    col=vim.o.columns,    -- col position
    width=25,             -- width of the window
    height=3,             -- height of the window
    title="Keystrokes",   -- title of the window
    title_pos="center",   -- title position
  })

  -- vim.api.nvim_buf_set_option(buf, "filetype", "keys")
end

function M.test ()
  -- vim.cmd([[autocmd CursorMoved,CursorMovedI * lua Handler(vim.fn.nr2char(vim.fn.getchar()))]])
  createWindow()
end

return M
