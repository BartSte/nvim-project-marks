local helpers = require "projectmarks.helpers"

---@class Mappings Set the mappings for the plugin.
---@field setup fun(opts: Options)
local M = {}

---
---@param opts Options
M.setup = function(opts)
  if opts.mappings == false then
    return
  end

  helpers.nnoremap("'", ":LastPosition<CR>")
  helpers.nnoremap("`", ":LastColumnPosition<CR>")
  helpers.nnoremap("m", ":AddMark<CR>")

  -- TODO override the default mark and delmark commands
end

return M
