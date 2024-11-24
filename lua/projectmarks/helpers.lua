---@class Helpers Helper functions for the projectmarks plugin.
local M = {}

--- Logs a message to the user.
---@param msg string The message to be displayed. If the message is empty, no
---notification is displayed.
---@param level number The level of the message.
---@param opts table|nil The opts that are passed to `vim.api.nvim_notify`. If
---not provided, the global options are used.
M.notify = function(msg, level, opts)
  if msg == '' then
    return
  end
  opts = opts or require('projectmarks').opts.message_opts
  vim.api.nvim_notify(msg, level, opts)
end

--- Helper function to map keys in normal mode.
---@param lhs string The key to be mapped.
---@param rhs string The action to be performed.
M.nnoremap = function(lhs, rhs)
  vim.api.nvim_set_keymap('n', lhs, rhs, { noremap = true, silent = true })
end



return M
