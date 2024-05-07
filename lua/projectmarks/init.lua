local shada = require "projectmarks.shada"
local commands = require "projectmarks.commands"
local mappings = require "projectmarks.mappings"
local marks = require "projectmarks.marks"
local abbreviations = require "projectmarks.abbreviations"

---@class Options The default options for the plugin.
---@field shadafile string If set to a string, the vim.go.shadafile is set to
---the given value, if it can be found by moving upwards in the file tree. If
---not found, the global shada file is used.
---@field mappings boolean If set to true, the "'" and "`" mappings are are
---appended by the `last_position`, and `last_column_position` functions,
---respectively.
---@field abbreviations boolean If set to true, the "mark" and "delmarks" command
---are replaced by the "Mark" and "DelMarks" using `cnoreabbrev`. This is useful
---when you rely on `lualine.marks_optimized` function, as the "Mark" and
---"DelMarks" commands will refresh lualine.
---@field message string Message to be displayed when jumping to a mark. Is only
---displayed if mappings are enabled.
local default_opts = {
  shadafile = 'nvim.shada',
  mappings = true,
  abbreviations = false,
  message = 'Waiting for mark...'
}

---@class UserOptions : Options The options provided by the user.
local M = {}

--- Setup the configuration for the plugin.
---@param user_opts UserOptions The options provided by the user.
M.setup = function(user_opts)
  M.opts = vim.tbl_deep_extend('force', default_opts, user_opts or {})
  shada.set_file(M.opts.shadafile)
  commands.setup(M.opts)
  mappings.setup(M.opts)
  abbreviations.setup(M.opts)
end

M.add_mark = commands.add_mark
M.jump_with = marks.jump_with
M.make_shada = shada.make
M.delete_mark = commands.delete_mark
M.last_position = marks.last_position
M.last_column_position = marks.last_column_position

return M
