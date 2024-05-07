local shada = require "projectmarks.shada"
local marks = require "projectmarks.marks"

---@class Lualine Lualine configurations.
---@field shada table The shada file configuration. When `shadafile` is set, the
---base name of the file is displayed with an icon.
---@field marks table The marks configuration. The marks that are set for the
---active buffer are displayed, together with an icon.
---@field marks_optimized table The marks configuration. The same as `marks`, but
---optimized for being polled. Make sure that `opts.mappings` is set to `true`,
---or that you call `projectmarks.marks.marks_optimized_refresh` when you
---add or remove a mark.
local M = {}

M.shada = {
  function() return shada.file() end,
  icon = "💾",
  cond = shada.has_file
}

M.marks = {
  function() return marks.concat() end,
  icon = "🔖",
}

M.marks_optimized = {
  function() return marks.concat_optimized() end,
  icon = "🔖",
}

return M
