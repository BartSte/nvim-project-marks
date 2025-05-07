local file = require('projectmarks.file')
local helpers = require('projectmarks.helpers')

local M = {}

--- Create a file at opts.shadafile if it does not exist. Otherwise, do nothing.
---@param shadafile string The path to the shada file.
M.make = function(shadafile)
  if shadafile == '' then
    helpers.notify('No shada file is set.', vim.log.levels.WARN)
  elseif file.exists(shadafile) then
    helpers.notify('Shada file already exists at ' .. shadafile, vim.log.levels.INFO)
  else
    file.create(shadafile)
  end
end

---Sets the vim.go.shadafile to the given value, if it can be found.
---@param path string If `path` is set to a string, the vim.go.shadafile
---is set to the given value, if it can be found by moving upwards in the file
---tree. If not found, the global shada file is used.
M.set_file = function(path)
  -- For backward compatibility. If it is true (boolean) we use 'nvim.shada', if
  -- it is false (boolean) we use ''
  if path == true then
    path = 'nvim.shada'
  elseif path == false then
    path = ''
  end
  vim.go.shadafile = vim.fn.findfile(path, '.;')
  vim.cmd("rshada!")
end

--- Return the name of the shada file.
---@return string name The name of the shada file.
M.shadafile = function()
  return vim.fn.fnamemodify(vim.go.shadafile, ":t")
end

--- Return true if the shada file is set. Otherwise, return false.
---@return boolean result True if the shada file is set, false otherwise.
M.has_file = function()
  return vim.go.shadafile ~= ""
end

return M
