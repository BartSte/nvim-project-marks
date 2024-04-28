---@class projectmarks.functions
---@field jump_with fun(symbol: string, message: string|nil)
---@field last_position fun(message: string|nil)
---@field last_column_position fun(message: string|nil)
local M = {}

local function jump_with(symbol)
  local mark = vim.fn.nr2char(vim.fn.getchar())
  local command = symbol .. mark
  if mark == string.upper(mark) then
    command = command .. symbol .. '"'
  end
  vim.api.nvim_feedkeys(command, 'n', false)
end

---When using a global mark, the following will be appended to the command:
---  {symbol}"
---For example, if we set symbol to `symbol='`, after calling a global mark
---`A`, the following command is triggered:
---  'A'"
---As, a result the cursor is returned to the last position ('") instead of the
---mark.
---@param symbol string The symbol to be used for the mark.
---@param message string|nil The message to be displayed when jumping to a mark.
M.jump_with = function(symbol, message)
  message = message or ""
  vim.api.nvim_notify(message, vim.log.levels.INFO, {})
  pcall(function() jump_with(symbol) end)
  vim.api.nvim_notify('', vim.log.levels.INFO, {})
end

---Return a function handle for `jump_with` where symbol is: ', i.e. last cursor
---position when last exiting the current buffer.
---@param message string|nil The message to be displayed when jumping to a mark.
M.last_position = function(message)
  M.jump_with("'", message)
end

---Return a function handle for `jump_with` where symbol is: `, i.e. last know
---row + column position.
---@param message string|nil The message to be displayed when jumping to a mark.
M.last_column_position = function(message)
  M.jump_with('`', message)
end

return M
