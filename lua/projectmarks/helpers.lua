---@class Helpers Helper functions for the projectmarks plugin.
local M = {}

--- Logs a message to the user.
---@param msg string The message to be displayed.
---@param level number The level of the message.
M.notify = function(msg, level)
  vim.api.nvim_notify(msg, level, {})
end

--- Helper function to map keys in normal mode.
---@param lhs string The key to be mapped.
---@param rhs string The action to be performed.
M.nnoremap = function(lhs, rhs)
  vim.api.nvim_set_keymap('n', lhs, rhs, { noremap = true, silent = true })
end



return M
