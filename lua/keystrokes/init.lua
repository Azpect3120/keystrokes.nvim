-- Imports the plugin's additional Lua modules.
-- local fetch = require("keystrokes.fetch")
-- local update = require("keystrokes.update")

-- Creates an object for the module. All of the module's
-- functions are associated with this object, which is
-- returned when the module is called with `require`.
local M = {}

local count = 0
local output = ""

function Handler (key)
  if count < 5 then
    output = output .. key
    count = count + 1
  else
    print(output)
    output = ""
    count = 0
  end
end

function M.test ()
  vim.cmd([[autocmd CursorMoved,CursorMovedI * lua Handler(vim.fn.nr2char(vim.fn.getchar()))]])
end

return M
