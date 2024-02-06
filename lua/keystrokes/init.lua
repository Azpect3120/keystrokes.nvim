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
    row=0,            -- row position
    col=vim.o.columns,          -- col position
    width=M.config.window.width or 25,
    height=M.config.window.height or 3,
    title=M.config.window.title or "Keystrokes",
    title_pos=M.config.window.title_pos or "center",
  })

  -- Update settings
  M.settings.buffer = buf
  M.settings.window = win
end

-- Toggle the window on and off
function M.toggle ()
  -- Toggle the window
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
  local window_width = M.config.window.width
  local padding = (" "):rep(math.floor((window_width-vim.api.nvim_strwidth(table.concat(keystrokes, " ")))/2))
  local set_lines = padding .. table.concat(keystrokes, " ") .. padding

  -- If the window is toggled on, update the window
  if M.config.toggled then
    vim.api.nvim_buf_set_lines(M.settings.buffer, 0, -1, false, {"", string.gsub(set_lines, "\n", ""), ""})
  end
end

-- Byte to special character mapping
local spec_table = {
  [32] = "␣",
  [13] = "⏎",
  [27] = "⎋",
  [58] = ":",
  [9] = "»",
}

-- Value to special character mapping
local val_table = {
  ["<BS>"] = "⌫",
  ["<CR>"] = "⏎",
  ["<Cmd>"] = ":",
  ["<Tab>"] = "»",
  ["<Esc>"] = "⎋",
  ["<Space>"] = "␣",
  ["<Up>"] = "↑",
  ["<Down>"] = "↓",
  ["<Left>"] = "←",
  ["<Right>"] = "→",
  ["<t_\253g>"] = "", -- weird lua stuff
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

  local translated = vim.fn.keytrans(key)

  local special = val_table[translated]
  if special ~= nil then
    return special
  end

  if translated:match('Left')
    or translated:match('Mouse')
    or translated:match('Scroll')
  then
    return "󰍽 "
  end

  return translated
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
  if not M.settings.listening then
    M.settings.listening = true
    vim.on_key(onKeystroke)
  end
end

-- Setup the plugin REQUIRED
function M.setup (config)
  -- Settings
  M.settings = {
    window = 0,       -- Holds the window handler OR 0 if no window
    buffer = 0,       -- Holds the buffer handler OR 0 if no buffer
    -- Holds the namespace handler
    namespace = vim.api.nvim_create_namespace("keystrokes"),
    listening = false, -- Whether the plugin is listening for keystrokes
  }

  -- Holds the keys that have been pressed
  M.keys = {}

  -- Default configuration
  M.config = {
    enabled_on_start = false, -- Whether the plugin is enabled on start (default: false)
    toggled = false,    -- Window is toggled (default: false)
    max_display = 5,   -- Maximum number of keystrokes to display (default: 5)
    window = {
      width = 25,      -- Width of the window (default: 25)
      height = 3,       -- Height of the window (default: 3)
      title = "Keystrokes", -- Title of the window (default: "Keystrokes")
      title_pos = "center", -- Title position (default: "center")
      border = "rounded",   -- Border style (default: "rounded")
    },
  }

  -- Enable the plugin on start if enabled_on_start is true
  if M.config.enabled_on_start then
    M.toggle()
  end


  -- Overwrite default configuration with provided config
  if config then
    for key, value in pairs(config) do
      M.config[key] = value
    end
  end
end

-- Return the module object
return M
