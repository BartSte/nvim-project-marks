---@class Helpers Helper functions for the projectmarks plugin.
---@field nnoremap function(lhs: string, rhs: string)
---@field log function(msg: string, level: number)
---@field message_decorator function(callback: function, message: string)
---@field exists function(filename: string)
---@field create_file function(filename: string)
---@field set_shadafile function(path: string)
---@field marks function(args: string|nil)
---@field mark_in_buffer function(bufnr: number, mark: string)
---@field find_marks function(bufnr: number)
local M = {}

local INFO = vim.log.levels.INFO
local ERROR = vim.log.levels.ERROR

--- Helper function to map keys in normal mode.
---@param lhs string The key to be mapped.
---@param rhs string The action to be performed.
M.nnoremap = function(lhs, rhs)
  vim.api.nvim_set_keymap('n', lhs, rhs, { noremap = true, silent = true })
end

--- Logs a message to the user.
---@param msg string The message to be displayed.
---@param level number The level of the message.
M.log = function(msg, level)
  vim.api.nvim_notify(msg, level, {})
end

--- Decorates a function with a message.
---@param callback function The function to be decorated.
---@param message string The message to be displayed.
---@return any result The result of `callback`.
M.message_decorator = function(callback, message)
  return function(...)
    M.log(message, INFO)
    local result = callback(...)
    M.log('', INFO)
    vim.api.nvim_command('redraw')
    return result
  end
end

--- Checks if a file exists.
---@param filename string The name of the file to be checked.
---@return boolean result True if the file exists, false otherwise.
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

--- Runs the `marks` with
---@param args string|nil The arguments to pass to the marks command
---@return table marks The marks of the current buffer
M.marks = function(args)
  args = args or "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
  local ok, result = pcall(vim.fn.execute, "marks " .. args)
  if ok then
    return vim.split(result, "\n")
  else
    return {}
  end
end

--- Return true if the mark exists in the buffer. Otherwise, return false.
---@param bufnr number The buffer number
---@param mark string The mark to check
---@return boolean
M.mark_in_buffer = function(bufnr, mark)
  local row_col = vim.api.nvim_buf_get_mark(bufnr, mark)
  return row_col[1] + row_col[2] > 0
end
---
--- Return a table of marks that exist in the buffer.
---@param bufnr number The buffer number
---@return table<string> marks The marks that exist in the buffer
M.find_marks = function(bufnr)
  local marks = {}
  for _, line in ipairs(M.marks()) do
    local mark = line:match("^ *([a-zA-Z]) ")
    if mark ~= nil and M.mark_in_buffer(bufnr, mark) then
      table.insert(marks, mark)
    end
  end
  return marks
end

return M
