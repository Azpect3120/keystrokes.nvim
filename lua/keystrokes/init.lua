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

function M.test ()
  vim.cmd([[autocmd CursorMoved,CursorMovedI * lua Handler(vim.fn.nr2char(vim.fn.getchar()))]])
end

return M
