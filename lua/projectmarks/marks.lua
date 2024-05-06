---@class Marks
local M = {}

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

--- Return true if the mark exists in the buffer. Otherwise, return false.
---@param bufnr number The buffer number
---@param mark string The mark to check
---@return boolean
local function is_in_buffer(bufnr, mark)
  local row_col = vim.api.nvim_buf_get_mark(bufnr, mark)
  return row_col[1] + row_col[2] > 0
end

--- Runs the `marks` with
---@param args string|nil The arguments to pass to the marks command
---@return table marks The marks of the current buffer
local function marks_cmd(args)
  args = args or "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
  local ok, result = pcall(vim.fn.execute, "marks " .. args)
  if ok then
    return vim.split(result, "\n")
  else
    return {}
  end
end

--- Return a table of marks that exist in the buffer.
---@param bufnr number The buffer number
---@return table<string> marks The marks that exist in the buffer
M.find = function(bufnr)
  local marks = {}
  for _, line in ipairs(marks_cmd()) do
    local mark = line:match("^ *([a-zA-Z]) ")
    if mark ~= nil and is_in_buffer(bufnr, mark) then
      table.insert(marks, mark)
    end
  end
  return marks
end

---Return the content of `:marks` for `bufnr` as a string.
---@param bufnr number|nil
---@return string marks The marks of the buffer
M.concat = function(bufnr)
  bufnr = bufnr or 0
  return table.concat(M.find(bufnr), " ")
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
M.concat_optimized = function()
  local buffer = vim.fn.bufnr()
  if buffer ~= latest_buffer then
    latest_buffer = buffer
    latest_marks = M.concat(buffer)
  end
  return latest_marks
end

--- Force a refresh of the stored marks in `marks_optimized`. This is useful when
--- the buffer has not changed but the marks have.
---@return string marks The marks of the current buffer
M.concat_optimized_refresh = function()
  latest_buffer = 0
  return M.concat_optimized()
end

---Add a mark to the current buffer. If `mark` is nil, it will prompt the user
---to enter a mark.
---@param mark string|nil
M.add = function(mark)
  local ok = true
  if mark == nil then
    ok, mark = pcall(function() return vim.fn.nr2char(vim.fn.getchar()) end)
  end
  if ok then
    vim.cmd("mark " .. mark)
  end
  M.concat_optimized_refresh()
end

---Delete a mark from the current buffer.
---@param mark string The mark to be deleted
M.delete = function(mark)
  vim.cmd("delmark " .. mark)
  M.concat_optimized_refresh()
end

return M
