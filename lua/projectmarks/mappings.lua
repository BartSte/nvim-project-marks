local helpers = require "projectmarks.helpers"

---@class Mappings Set the mappings for the plugin.
---@field setup fun(opts: Options)
local M = {}

--- The following mappings are set:
--- - ' -> when using a upper case mark, it will jump to the last position of of
--- the cursor in the file, instead of the mark it self.
--- - ` -> when using a upper case mark, it will jump to the last column position
--- of the cursor in the file, instead of the mark it self.
--- - m -> the mark_optimized_refresh function is called once the mark is set.
---
--- Furthermore, the following command line abbreviations are set:
--- - mark -> AddMark
--- - delmarks -> DelMarks
--- Both abbreviations ensure that the mark_optimized_refresh function is called
--- once the mark is set or deleted.
---@param opts Options
M.setup = function(opts)
  if opts.mappings == false then
    return
  end

  --TODO: when aborting the jump commands belwo, and error is thrown. This is
  --not nice.
  helpers.nnoremap("'", ":LastPosition<CR>")
  helpers.nnoremap("`", ":LastColumnPosition<CR>")
  helpers.nnoremap("m", ":AddMark<CR>")

  --TODO: these abbreviations are not yet working...
  vim.cmd [[ cnoreabbrev mark AddMark ]]
  vim.cmd [[ cnoreabbrev delmarks DelMarks ]]
end

return M
