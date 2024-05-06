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

return M
