local decorators = require 'projectmarks.decorators'
local marks = require 'projectmarks.marks'
local shada = require 'projectmarks.shada'

---@class Commands Command that combine the user option with the
---`projectmarks.functions`.
---@field make_shada fun(shadafile: string)
---@field add_mark fun(mark: string|nil)
---@field delete_mark fun(mark: string)
---@field last_position fun(message: string|nil)
---@field last_column_position fun(message: string|nil)
---@field setup fun(opts: Options)
local M = {}

---Setup the commands for the plugin.
---@param opts Options The options for the plugin.
M.setup = function(opts)
  M.make_shada = function() shada.make(opts.shadafile) end
  M.add_mark = decorators.message(marks.add, opts.message)
  M.delete_mark = decorators.message(marks.delete, opts.message)
  M.last_position = decorators.message(marks.last_position, opts.message)
  M.last_column_position = decorators.message(marks.last_column_position, opts.message)

  vim.cmd [[command! -nargs=? Mark lua require'projectmarks.commands'.add_mark(<f-args>)]]
  vim.cmd [[command! -nargs=1 DelMarks lua require'projectmarks.commands'.delete_mark(<f-args>)]]
  vim.cmd [[command! -nargs=0 MakeShada lua require'projectmarks.commands'.make_shada(require'projectmarks'.opts.shadafile)]]
  vim.cmd [[command! -nargs=0 LastPosition lua require'projectmarks.commands'.last_position()]]
  vim.cmd [[command! -nargs=0 LastColumnPosition lua require'projectmarks.commands'.last_column_position()]]
end

return M
