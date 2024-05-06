local func = require 'projectmarks.functions'
local decorate = require 'projectmarks.helpers'.message_decorator

---@class Commands Command that combine the user option with the
---`projectmarks.functions`.
---@field add_mark fun(mark: string|nil)
---@field make_shada fun(shadafile: string)
---@field last_position fun(message: string|nil)
---@field last_column_position fun(message: string|nil)
---@field setup fun(opts: Options)
local M = {}

---Setup the commands for the plugin.
---@param opts Options The options for the plugin.
M.setup = function(opts)
  M.add_mark = decorate(func.add_mark, opts.message)
  M.make_shada = function() func.make_shada(opts.shadafile) end
  M.last_position = decorate(func.last_position, opts.message)
  M.last_column_position = decorate(func.last_column_position, opts.message)

  vim.cmd [[command! -nargs=0 MakeShada lua require'projectmarks.commands'.make_shada(require'projectmarks'.opts.shadafile)]]
  vim.cmd [[command! -nargs=? AddMark lua require'projectmarks.commands'.add_mark(<f-args>)]]
  vim.cmd [[command! -nargs=0 LastPosition lua require'projectmarks.commands'.last_position()]]
  vim.cmd [[command! -nargs=0 LastColumnPosition lua require'projectmarks.commands'.last_column_position()]]
end

return M
