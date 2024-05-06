local helpers = require "projectmarks.helpers"

local M = {}

--- Checks if a file exists.
---@param filename string The name of the file to be checked.
---@return boolean result True if the file exists, false otherwise.
M.exists = function(filename)
  filename = vim.fn.expand(filename)
  return vim.fn.filereadable(filename) == 1
end

--- Creates a file at the given path.
---@param filename string The name of the file to be created.
M.create = function(filename)
  filename = vim.fn.expand(filename)
  local file = io.open(filename, 'w')
  if file then
    file:close()
    helpers.notify('File created at: ' .. filename, vim.log.levels.INFO)
  else
    helpers.notify('Cannot create file at: ' .. filename, vim.log.levels.ERROR)
  end
end

return M
