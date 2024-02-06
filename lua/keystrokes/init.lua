-- Imports the plugin's additional Lua modules.
-- local fetch = require("keystrokes.fetch")
-- local update = require("keystrokes.update")

-- Creates an object for the module. All of the module's
-- functions are associated with this object, which is
-- returned when the module is called with `require`.
local M = {}

-- Create a window for the keystrokes
function M.createWindow ()
  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, false, {
    relative="editor",          -- creates float when specified
    style="minimal",            -- remove the normal vim setup
    border="rounded",           -- options: "single", "double", "shadow", "rounded", "none", "solid", or array of 8 characters. eg. [ "╔", "═" ,"╗", "║", "╝", "═", "╚", "║" ]
    row=vim.o.lines,            -- row position
    col=vim.o.columns,          -- col position
    width=100,                   -- width of the window
    height=3,                   -- height of the window
    title="Keystrokes",         -- title of the window
    title_pos="center",         -- title position
  })

  -- Update settings
  M.settings.buffer = buf
  M.settings.window = win
end

-- Toggle the window on and off
function M.toggle ()
  M.config.toggled = not M.config.toggled

  -- If the window is toggled on, create the window
  -- If the window is toggled off, close the window
  if M.config.toggled then
    M.createWindow()
    M.start()
  else
    vim.api.nvim_win_close(M.settings.window, true)
  end
end

-- Update the window with the current keystrokes
function M.update ()
  -- Get the current keystrokes
  local keystrokes = M.keys

  -- Text in the center of the window
  local window_width = 25     -- WIP: Get from window
  local padding = (" "):rep(math.floor((window_width-vim.api.nvim_strwidth(table.concat(keystrokes, " ")))/2))
  local set_lines = padding .. table.concat(keystrokes, " ") .. padding

  -- If the window is toggled on, update the window
  if M.config.toggled then
    vim.api.nvim_buf_set_lines(M.settings.buffer, 0, -1, false, {"", set_lines, ""})
  end
end

-- TODO: ⇧+ (for shift+), ⌥+ (for alt+) (also see: https://wincent.com/wiki/Unicode_representations_of_modifier_keys)
--[[ local spec_table = {
    [9] = " ", [13] = "⏎ ", [27] = "⎋", [32] = "␣",
    [127] = "", [8] = "⌫ ", -- Not working
    
}
local spc = {
    ["<BS>"] = "⌫ ",
    ["<t_\253g>"] = " ", -- lua function (is this really needed?)
    ["<Cmd>"] = "",
}
]]

local spec_table = {
  [32] = "␣",
  [13] = "⏎",
  [128] = "⌫",
  [58] = ":",
  [9] = "»",
}

local val_table = {
  ["<BS>"] = "⌫",
  ["<CR>"] = "⏎",
  ["<Cmd>"] = "",
}
-- Sanitize the keystrokes
local function sanitize (key)
  local b = key:byte()
  for k, v in pairs(spec_table) do
    if b == k then
      return v
    end
  end

  if b <= 126 and b >= 33 then
    return string.char(b)
  end

  return b

  --[[ local translated = vim.fn.keytrans(key)
  return translated ]]

  --[[ for k, v in pairs(val_table) do
    if translated == k then
      return v
    end
  end ]]

  -- return key
end

-- Handle the keystrokes
local function onKeystroke (key)
  if #M.keys >= M.config.max_display then
    table.remove(M.keys, 1)
  end
  table.insert(M.keys, sanitize(key))
  M.update()
end

-- Start the watcher
function M.start ()
  vim.on_key(onKeystroke)
end


-- Setup the plugin REQUIRED
function M.setup (config)
  -- Settings
  M.settings = {
    window = 0,       -- Holds the window handler OR 0 if no window
    buffer = 0,       -- Holds the buffer handler OR 0 if no buffer
    -- Holds the namespace handler
    namespace = vim.api.nvim_create_namespace("keystrokes"),
  }

  -- Holds the keys that have been pressed
  M.keys = {}

  -- Default configuration
  M.config = {
    toggled = false,    -- Window is toggled (default: false)
    max_display = 10,   -- Maximum number of keystrokes to display (default: 10)
  }

  -- Overwrite default configuration with provided config
  if config then
    for key, value in pairs(config) do
      M.config[key] = value
    end
  end
end

-- Return the module object
return M
