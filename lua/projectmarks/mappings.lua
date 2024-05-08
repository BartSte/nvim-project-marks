local marks = require "projectmarks.marks"
local helpers = require "projectmarks.helpers"
local decorators = require "projectmarks.decorators"

---@class Mappings Set the mappings for the plugin.
---@field setup fun(opts: Options)
---@field add_mark fun() Same as require'projectmarks'.add_mark but now a
---message is displayed and error are caught.
---@field last_position fun() Same as require'projectmarks'.last_position but
---now a message is displayed and error are caught.
---@field last_column_position fun() Same as
---require'projectmarks'.last_column_position but now a message is displayed and
---the error are caught.
local M = {}

--- Decorate a function with a message to be displayed and error catching.
---@param func function The function to be decorated.
---@param message string The message to be displayed.
---@return function returns a decorated function.
local function decorate(func, message)
  return decorators.message(
    decorators.pcall(func),
    message
  )
end

--- The following mappings are set:
--- - ' -> when using a upper case mark, it will jump to the last position of of
--- the cursor in the file, instead of the mark it self.
--- - ` -> when using a upper case mark, it will jump to the last column position
--- of the cursor in the file, instead of the mark it self.
--- - m -> the mark_optimized_refresh function is called once the mark is set.
---
--- Furthermore, the following command line abbreviations are set:
--- - mark -> Mark
--- - delmarks -> DelMarks
--- Both abbreviations ensure that the mark_optimized_refresh function is called
--- once the mark is set or deleted.
---@param opts Options
M.setup = function(opts)
  M.add_mark = decorate(marks.add, opts.message)
  M.last_position = decorate(marks.last_position, opts.message)
  M.last_column_position = decorate(marks.last_column_position, opts.message)

  if opts.mappings then
    local prefix = "<cmd>lua require'projectmarks.mappings'"
    helpers.nnoremap("'", prefix .. ".last_position()<CR>")
    helpers.nnoremap("`", prefix .. ".last_column_position()<CR>")
    helpers.nnoremap("m", prefix .. ".add_mark()<CR>")
  end
end

return M
