" Title:        Keystrokes.nvim
" Description:  A plugin that provides a popup window to display keystrokes.
" Last Change:  4 February 2024
" Maintainer:   Azpect3120 <https://github.com/Azpect3120>

" Prevents the plugin from being loaded multiple times. If the loaded
" variable exists, do nothing more. Otherwise, assign the loaded
" variable and continue running this instance of the plugin.
if exists("g:loaded_keystrokes")
    finish
endif
let g:loaded_exampleplugin = 1

" Defines a package path for Lua. This facilitates importing the
" Lua modules from the plugin's dependency directory.
let s:lua_rocks_deps_loc =  expand("<sfile>:h:r") . "/../lua/keystrokes/deps"
exe "lua package.path = package.path .. ';" . s:lua_rocks_deps_loc . "/lua-?/init.lua'"

" Exposes the plugin's functions for use as commands in Neovim.
command! -nargs=0 FetchTodos lua require("keystrokes").fetch_todos()
command! -nargs=0 InsertTodo lua require("keystrokes").insert_todo()
command! -nargs=0 CompleteTodo lua require("keystrokes").complete_todo()
