local M = {}

--- Setup the abbreviations for the plugin.
---@param opts Options The options provided by the user.
M.setup = function(opts)
  if opts.abbreviations then
    vim.cmd("cnoreabbrev mark Mark")
    vim.cmd("cnoreabbrev delmarks DelMarks")
  end
end

return M
