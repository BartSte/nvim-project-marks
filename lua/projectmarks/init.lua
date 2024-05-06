local helpers = require('projectmarks.helpers')
local commands = require('projectmarks.commands')
local mappings = require('projectmarks.mappings')

---@class Options The default options for the plugin.
---@field shadafile string If set to a string, the vim.go.shadafile is set to
---the given value, if it can be found by moving upwards in the file tree. If
---not found, the global shada file is used.
---@field mappings boolean If set to true, the "'" and "`" mappings are are
---appended by the `last_position`, and `last_column_position` functions,
---respectively.
---@field message string Message to be displayed when jumping to a mark. Is only
---displayed if mappings are enabled.
local default_opts = {
  shadafile = 'nvim.shada',
  mappings = true,
  message = 'Waiting for mark...'
}

---@class UserOptions : Options The options provided by the user.
local M = {}

--- Setup the configuration for the plugin.
---@param user_opts UserOptions The options provided by the user.
M.setup = function(user_opts)
  M.opts = vim.tbl_deep_extend('force', default_opts, user_opts or {})
  helpers.set_shadafile(M.opts.shadafile)
  commands.setup(M.opts)
  mappings.setup(M.opts)
end

return M
