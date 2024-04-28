local helpers = require 'projectmarks.helpers'

local function show_error()
  error('projectmarks.setup() must be called before setup()')
end

---@class projectmarks.commands
---@field make_shada fun(shadafile: string)
---@field setup fun(opts: table)
local M = {
  make_shada = show_error,
}

--- Create a file at opts.shadafile if it does not exist. Otherwise, do nothing.
---@param shadafile string The path to the shada file.
local function make_shada(shadafile)
  if shadafile == '' then
    helpers.log('No shada file is set.', vim.log.levels.WARN)
  elseif helpers.exists(shadafile) then
    helpers.log('Shada file already exists at ' .. shadafile, vim.log.levels.INFO)
  else
    helpers.create_file(shadafile)
  end
end

---Setup the commands for the plugin.
---@param opts Options The options for the plugin.
M.setup = function(opts)
  M.make_shada = function() make_shada(opts.shadafile) end

  vim.cmd [[command! -nargs=0 MakeShada lua require'projectmarks.commands'.make_shada(require'projectmarks'.opts.shadafile)]]
end

return M
