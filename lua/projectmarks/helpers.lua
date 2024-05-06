---@class Helpers Helper functions for the projectmarks plugin.
local M = {}

--- Helper function to map keys in normal mode.
---@param lhs string The key to be mapped.
---@param rhs string The action to be performed.
M.nnoremap = function(lhs, rhs)
  vim.api.nvim_set_keymap('n', lhs, rhs, { noremap = true, silent = true })
end

--- Logs a message to the user.
---@param msg string The message to be displayed.
---@param level number The level of the message.
M.notify = function(msg, level)
  vim.api.nvim_notify(msg, level, {})
end

--- Decorates a function with a message.
---@param callback function The function to be decorated.
---@param message string The message to be displayed.
---@return any result The result of `callback`.
M.decorate_message = function(callback, message)
  return function(...)
    M.notify(message, vim.log.levels.INFO)
    local result = callback(...)
    M.notify('', vim.log.levels.INFO)
    vim.api.nvim_command('redraw')
    return result
  end
end


return M
