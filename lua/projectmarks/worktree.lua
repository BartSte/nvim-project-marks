local M = {}

local uv = vim.uv or vim.loop

local function git_context(directory)
  local paths = vim.fn.systemlist({
    'git', '-C', directory, 'rev-parse', '--path-format=absolute',
    '--show-toplevel', '--git-common-dir',
  })
  if vim.v.shell_error ~= 0 or #paths ~= 2 then
    return
  end

  return uv.fs_realpath(paths[1]), uv.fs_realpath(paths[2])
end

--- Find the equivalent path in the active worktree of the same repository.
---@param path string Path stored in a file mark.
---@return string|nil path The target path, even if the target file is missing.
function M.resolve(path)
  if vim.fn.executable('git') ~= 1 then
    return
  end

  local marked_dir = uv.fs_realpath(vim.fn.fnamemodify(path, ':p:h'))
  if not marked_dir then
    return
  end

  local current_path = vim.api.nvim_buf_get_name(0)
  local current_dir = vim.fn.getcwd()
  if vim.bo.buftype == '' and current_path ~= '' then
    current_dir = vim.fs.dirname(current_path)
  end

  local active_root, active_common = git_context(current_dir)
  if not active_root or not active_common then
    return
  end

  local marked_root, marked_common = git_context(marked_dir)
  if not marked_root or marked_root == active_root or marked_common ~= active_common then
    return
  end

  local prefix = vim.fs.normalize(marked_root):gsub('/$', '') .. '/'
  local marked_path = vim.fs.normalize(marked_dir .. '/' .. vim.fn.fnamemodify(path, ':t'))
  if vim.startswith(marked_path, prefix) then
    return vim.fs.normalize(active_root .. '/' .. marked_path:sub(#prefix + 1))
  end
end

return M
