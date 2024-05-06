local func = require("projectmarks.functions")

---@class Lualine Lualine configurations.
---@field shada table The shada file configuration. When `shadafile` is set, the
---base name of the file is displayed with an icon.
---@field marks table The marks configuration. The marks that are set for the
---active buffer are displayed, together with an icon.
---@field marks_optimized table The marks configuration. The same as `marks`, but
---optimized for being polled. Make sure that `opts.mappings` is set to `true`,
---or that you call `projectmarks.functions.marks_optimized_refresh` when you
---add or remove a mark.
local M = {}

local function shadafile()
  return vim.fn.fnamemodify(vim.go.shadafile, ":t")
end

local function has_shadafile()
  return vim.go.shadafile ~= ""
end

M.shada = {
  shadafile,
  icon = "💾",
  cond = has_shadafile
}

M.marks = {
  function() return func.marks() end,
  icon = "🔖",
}

M.marks_optimized = {
  function() return func.marks_optimized() end,
  icon = "🔖",
}

return M
