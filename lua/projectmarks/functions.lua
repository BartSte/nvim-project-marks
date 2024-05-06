local helpers = require "projectmarks.helpers"

---@class Functions The functionality of the plugin captured as a set of
---functions.
---@field make_shada fun(shadafile: string)
---@field jump_with fun(symbol: string, message: string|nil)
---@field last_position fun(message: string|nil)
---@field last_column_position fun(message: string|nil)
---@field marks fun(bufnr: number|nil): string
---@field marks_optimized fun(): string
---@field marks_optimized_refresh fun()
---@field add_mark fun(mark: string|nil)
local M = {}

--- Create a file at opts.shadafile if it does not exist. Otherwise, do nothing.
---@param shadafile string The path to the shada file.
M.make_shada = function(shadafile)
  if shadafile == '' then
    helpers.log('No shada file is set.', vim.log.levels.WARN)
  elseif helpers.exists(shadafile) then
    helpers.log('Shada file already exists at ' .. shadafile, vim.log.levels.INFO)
  else
    helpers.create_file(shadafile)
  end
end

---When using a upper case mark, the following will be appended to the command:
---  {symbol}"
---For example, if we set symbol to `symbol='`, after calling a global mark
---`A`, the following command is triggered:
---  'A'"
---As, a result the cursor is returned to the last position ('") instead of the
---mark.
---@param symbol string The symbol to be used for the mark.
M.jump_with = function(symbol)
  local mark = vim.fn.nr2char(vim.fn.getchar())
  local command = symbol .. mark
  if mark == string.upper(mark) then
    command = command .. symbol .. '"'
  end
  vim.api.nvim_feedkeys(command, 'n', false)
end

---Return a function handle for `jump_with` where symbol is: ', i.e. last cursor
---position when last exiting the current buffer.
M.last_position = function() M.jump_with("'") end

---Return a function handle for `jump_with` where symbol is: `, i.e. last know
---row + column position.
M.last_column_position = function() M.jump_with("`") end

---Return the content of `:marks` for `bufnr` as a string.
---@param bufnr number|nil
---@return string marks The marks of the buffer
M.marks = function(bufnr)
  bufnr = bufnr or 0
  return table.concat(helpers.find_marks(bufnr), " ")
end

local latest_buffer = 0
local latest_marks = ""
--- Same as `marks` but optimized for being called by a timer during a polling
--- strategy. It stores the buffer number and the corresponding marks is a local
--- variable. If the buffer number is the same as the last time it was called,
--- it returns the stored marks. Otherwise, it calls `marks` and stores the
--- result. `marks_optimized_refresh` can be used to force a refresh of the
--- stored marks.
---@return string marks The marks of the current buffer
M.marks_optimized = function()
  local buffer = vim.fn.bufnr()
  if buffer ~= latest_buffer then
    latest_buffer = buffer
    latest_marks = M.marks(buffer)
  end
  return latest_marks
end

--- Force a refresh of the stored marks in `marks_optimized`. This is useful when
--- the buffer has not changed but the marks have.
---@return string marks The marks of the current buffer
M.marks_optimized_refresh = function()
  latest_buffer = 0
  return M.marks_optimized()
end

---Add a mark to the current buffer. If `mark` is nil, it will prompt the user
---to enter a mark.
---@param mark string|nil
M.add_mark = function(mark)
  local ok = true
  if mark == nil then
    ok, mark = pcall(function() return vim.fn.nr2char(vim.fn.getchar()) end)
  end
  if ok then
    vim.cmd("mark " .. mark)
  end
  M.marks_optimized_refresh()
end

---Delete a mark from the current buffer.
---@param mark string The mark to be deleted
M.delete_mark = function(mark)
  vim.cmd("delmark " .. mark)
  M.marks_optimized_refresh()
end

return M
