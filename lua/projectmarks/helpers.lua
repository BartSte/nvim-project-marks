---@class projectmarks.helpers The helpers module for the projectmarks plugin.
---@field set_shadafile fun(path: string) Sets the vim.go.shadafile to the given
---value, if it can be found.
---@field set_mappings fun(message: string) Enables the mappings for the plugin.
local M = {}

local INFO = vim.log.levels.INFO
local ERROR = vim.log.levels.ERROR

--- Logs a message to the user.
---@param msg string The message to be displayed.
---@param level number The level of the message.
M.log = function(msg, level)
  vim.api.nvim_notify(msg, level, {})
end

--- Checks if a file exists.
---@param filename string The name of the file to be checked.
---@return boolean True if the file exists, false otherwise.
M.exists = function(filename)
  filename = vim.fn.expand(filename)
  return vim.fn.filereadable(filename) == 1
end

--- Creates a file at the given path.
---@param filename string The name of the file to be created.
M.create_file = function(filename)
  filename = vim.fn.expand(filename)
  local file = io.open(filename, 'w')
  if file then
    file:close()
    M.log('Shada file created at: ' .. filename, INFO)
  else
    M.log('Cannot create shada at: ' .. filename, ERROR)
  end
end

---Sets the vim.go.shadafile to the given value, if it can be found.
---@param path string If `path` is set to a string, the vim.go.shadafile
---is set to the given value, if it can be found by moving upwards in the file
---tree. If not found, the global shada file is used.
M.set_shadafile = function(path)
  -- For backward compatibility. If it is true (boolean) we use 'nvim.shada', if
  -- it is false (boolean) we use ''
  if path == true then
    path = 'nvim.shada'
  elseif path == false then
    path = ''
  end

  vim.go.shadafile = vim.fn.findfile(path, '.;')
end

local function make_last_position(message)
  return function()
    require("projectmarks.functions").jump_with("'", message)
  end
end

local function make_last_column_position(message)
  return function()
    require("projectmarks.functions").jump_with('`', message)
  end
end

---The functions last_position and last_column_position are mapped to the
---`'` and '`' keys, respectively. Also, the `message` is displayed when
---jumping one of these keys is triggered.
---@param message string The message to be displayed when jumping to a mark.
M.set_mappings = function(message)
  vim.keymap.set('n', "'", make_last_position(message), { noremap = false })
  vim.keymap.set('n', "`", make_last_column_position(message), { noremap = false })
end

return M
