local M = {}

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
  local mark = vim.fn.nr2char(vim.fn.getchar())
  local command = symbol .. mark

  if mark == string.upper(mark) then
    command = command .. symbol .. '"'
  end
  vim.api.nvim_feedkeys(command, 'n', false)
end

-- Same as `_jump_with` but wrapped in a pcall. This is necessary because
-- `vim.fn.getchar()` throws an error if no input is given.
-- @param args table
M.jump_with = function(args)
  vim.api.nvim_notify(M.config.message, vim.log.levels.INFO, {})
  pcall(function() _jump_with(args) end)
  vim.api.nvim_notify('', vim.log.levels.INFO, {})
end

--- returns a function handle for `jump_with` where symbol is: ', i.e. last
--- To the cursor position when last exiting the current buffer.
M.last_position = function()
  M.jump_with("'")
end

-- returns a function handle for `jump_with` where symbol is: `, i.e. last
-- know row + column position.
M.last_column_position = function()
  M.jump_with('`')
end

-- Default configuration
---@type table
---@field shadafile string|boolean
---@field mappings boolean
---@field message string
local default = {
  -- If set to a string, the path to the shada file is set to the given value.
  -- If set to a boolean, the global shada file of neovim is used.
  shadafile = 'nvim.shada',

  -- If set to true, the "'" and "`" mappings are are appended by the
  -- `last_position`, and `last_column_position` functions, respectively.
  mappings = true,

  -- Message to be displayed when jumping to a mark.
  message = 'Waiting for mark...'
}

--- Setup the configuration for the plugin.
---@param opts table
M.setup = function(opts)
  M.config = vim.tbl_deep_extend('force', default, opts or {})

  -- If the `shadafile` option is true or a string, we will look for a local
  -- shada file.
  if M.config.shadafile then
    -- If the `shadafile` option is set to true, use the default value. Otherwise,
    -- use the given value.
    local name
    if M.config.shadafile == true then
      name = 'nvim.shada'
    else
      name = M.config.shadafile
    end
    -- Searches directoties upward for a shada file. If found this file can be
    -- interpreted as the "project-shada", containing project specific data. For
    -- example, marks. If not found, nil is returned. As a result, the `shadafile`
    -- option is empty and the global shada file is used.
    vim.go.shadafile = vim.fn.findfile(name, '.;')
  end

  -- If mappings are enabled, the following mappings are appended to the
  -- `last_position` and `last_column_position` functions, respectively.
  if M.config.mappings then
    vim.keymap.set('n', "'", M.last_position, { noremap = false })
    vim.keymap.set('n', "`", M.last_column_position, { noremap = false })
  end
end

return M
