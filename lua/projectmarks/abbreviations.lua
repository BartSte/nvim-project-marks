local M = {}

M.colon_abbrev = function(keyword, expansion)
  if vim.fn.getcmdtype() == ':' and vim.fn.getcmdline() == keyword then
    return expansion
  end
  return keyword
end

local function make_expr_cmd_colon_abbrev(keyword, expansion)
  local cmd = [[luaeval("require('projectmarks.abbreviations').colon_abbrev('%s', '%s')")]]
  return string.format(cmd, keyword, expansion)
end

--- Setup the abbreviations for the plugin.
---@param opts Options The options provided by the user.
M.setup = function(opts)
  if opts.abbreviations then
    local mark = make_expr_cmd_colon_abbrev("mark", "Mark")
    local delmarks = make_expr_cmd_colon_abbrev("delmarks", "DelMarks")
    vim.cmd [[
      cnoreabbrev <expr> mark luaeval("require('projectmarks.abbreviations').colon_abbrev('mark', 'Mark')")
      cnoreabbrev <expr> delmarks luaeval("require('projectmarks.abbreviations').colon_abbrev('delmarks', 'DelMarks')")
    ]]
  end
end

return M
