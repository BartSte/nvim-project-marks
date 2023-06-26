M = {}
--- When using a global mark, the following will be appended to the command:
--      {symbol}"
--  For example, if we set symbol to `symbol='`, after calling a global mark
--  `A`, the following command is triggered:
--      'A'"
--  As, a result the cursor is returned to the last position ('") instead of the
--  mark.
--
---@param symbol string
local function _jump_with(symbol)
  print('Waiting for mark...')
  local mark = vim.fn.nr2char(vim.fn.getchar())
  local command = symbol .. mark

  if mark == string.upper(mark) then
    command = command .. symbol .. '"'
  end
  vim.api.nvim_feedkeys(command, 'n', false)
end

-- Same as `jump_with` but wrapped in a pcall. This is necessary because
-- `vim.fn.getchar()` throws an error if no input is given.
-- @param args table
local function jump_with(args)
  pcall(function() _jump_with(args) end)
end

--- returns a function handle for `jump_with` where symbol is: ', i.e. last
--- To the cursor position when last exiting the current buffer.
--- @return function
M.last_position = function()
  return function()
    jump_with("'")
    print('\n')
  end
end

--- returns a function handle for `jump_with` where symbol is: `, i.e. last
--- know row + column position.
---@return function
M.last_column_position = function()
  return function()
    jump_with('`')
    print('\n')
  end
end

vim.keymap.set('n', "'", M.last_position, { noremap = false })
vim.keymap.set('n', "`", M.last_column_position, { noremap = false })
--
-- Searches directoties upward for a shada file. If found this file can be
-- interpreted as the "project-shada", conainint project specific data. For
-- example, marks. If not found, the global shada file of neovim is used.
vim.go.shadafile = vim.fn.findfile('nvim.shada', '.;')
