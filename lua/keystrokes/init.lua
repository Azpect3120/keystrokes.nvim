-- Imports the plugin's additional Lua modules.
-- local fetch = require("keystrokes.fetch")
-- local update = require("keystrokes.update")

-- Creates an object for the module. All of the module's
-- functions are associated with this object, which is
-- returned when the module is called with `require`.
local M = {}

-- Routes calls made to this module to functions in the
-- plugin's other modules.
-- M.fetch_todos = fetch.fetch_todos
-- M.insert_todo = update.insert_todo
-- M.complete_todo = update.complete_todo

function Handler (key)
  print(key)
end

function M.test ()
  vim.on_key(Handler)
end
return M
