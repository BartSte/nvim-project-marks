local helpers = require('projectmarks.helpers')

local M = {}

--- Try to execute a function and return the result.
---@param callback function The function to be executed.
---@return any|nil result The result of the function or nil if an error occurred.
M.pcall = function(callback)
  return function(...)
    local ok, result = pcall(callback, ...)
    if ok then
      return result
    else
      return nil
    end
  end
end

--- Decorates a function with a message.
---@param callback function The function to be decorated.
---@param message string The message to be displayed.
---@return any result The result of `callback`.
M.message = function(callback, message)
  return function(...)
    helpers.notify(message, vim.log.levels.INFO)
    local result = callback(...)
    helpers.notify('', vim.log.levels.INFO)
    vim.api.nvim_command('redraw')
    return result
  end
end

return M
