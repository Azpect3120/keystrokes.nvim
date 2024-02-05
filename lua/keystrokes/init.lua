-- Imports the plugin's additional Lua modules.
-- local fetch = require("keystrokes.fetch")
-- local update = require("keystrokes.update")

-- Creates an object for the module. All of the module's
-- functions are associated with this object, which is
-- returned when the module is called with `require`.
local M = {}

-- Create a window for the keystrokes
function M.CreateWindow ()
  -- nvim_create_buf({listed}, {scratch}): buffer handler OR 0 on error
  local buf = vim.api.nvim_create_buf(false, true)

  -- nvim_open_win(){buffer}, {enter}, {*config}): window handler OR 0 on error
  local win = vim.api.nvim_open_win(buf, false, {
    relative="editor",          -- creates float when specified
    style="minimal",            -- remove the normal vim setup
    border="rounded",           -- options: "single", "double", "shadow", "rounded", "none", "solid", or array of 8 characters. eg. [ "╔", "═" ,"╗", "║", "╝", "═", "╚", "║" ]
    row=vim.o.lines,            -- row position
    col=vim.o.columns + 25,     -- col position
    width=25,                   -- width of the window
    height=3,                   -- height of the window
    title="Keystrokes",         -- title of the window
    title_pos="center",         -- title position
  })

  M.settings.window = win
end

-- Toggle the window on and off
function M.toggle ()
  M.config.toggled = not M.config.toggled

  -- If the window is toggled on, create the window
  -- If the window is toggled off, close the window
  if M.config.toggled then
    M.CreateWindow()
  else
    -- nvim_win_close({window}, {force}): boolean
    vim.api.nvim_win_close(M.settings.window, true)
  end
end


function M.setup (config)
  -- Settings
  M.settings = {
    window = 0
  }

  -- Default configuration
  M.config = {
    toggled = false,
    max_display = 10
  }

  -- Overwrite default configuration with provided config
  if config then
    for key, value in pairs(config) do
      M.config[key] = value
    end
  end
end

return M
