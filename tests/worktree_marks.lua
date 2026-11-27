vim.opt.runtimepath:append('.')

local directory = vim.fn.tempname()
vim.fn.mkdir(directory, 'p')

local function git(root, ...)
  local output = vim.fn.system(vim.list_extend({ 'git', '-C', root }, { ... }))
  assert(vim.v.shell_error == 0, output)
end

local function repository(root)
  vim.fn.mkdir(root .. '/src', 'p')
  git(root, 'init', '-q')
  vim.fn.writefile({ 'first', 'second', 'third', '  fourth' }, root .. '/src/api client.py')
  vim.fn.writefile({ 'start' }, root .. '/start.txt')
  git(root, 'add', '.')
  git(root, '-c', 'user.name=Test', '-c', 'user.email=test@example.invalid',
    '-c', 'commit.gpgsign=false', 'commit', '-qm', 'Base')
end

local function press(keys)
  vim.api.nvim_feedkeys(vim.keycode(keys), 'xt', false)
end

local function edit(path)
  vim.cmd.edit({ args = { path } })
end

local function expect_file(path)
  local current = vim.api.nvim_buf_get_name(0)
  assert(current == path, ('Expected %s, got %s'):format(path, current))
end

local ok, err = xpcall(function()
  local main = directory .. '/main checkout'
  local linked = directory .. '/linked checkout'
  local unrelated = directory .. '/other checkout'
  repository(main)
  git(main, 'worktree', 'add', '-q', '--detach', linked)
  repository(unrelated)

  local file = '/src/api client.py'
  local shada = directory .. '/marks.shada'
  local projectmarks = require('projectmarks')

  edit(main .. file)
  vim.api.nvim_win_set_cursor(0, { 2, 2 })
  press('mA')
  vim.cmd.wshada({ bang = true, args = { shada } })

  projectmarks.setup({ shadafile = shada, message = '' })
  edit(linked .. '/start.txt')
  press("'A")
  expect_file(main .. file)

  projectmarks.setup({ shadafile = shada, message = '', worktree_relative = true })
  edit(linked .. file)
  vim.api.nvim_win_set_cursor(0, { 4, 4 })
  edit(linked .. '/start.txt')
  local saved_mark = vim.api.nvim_get_mark('A', {})

  press('`A')
  expect_file(linked .. file)
  assert(vim.deep_equal(vim.api.nvim_win_get_cursor(0), { 4, 4 }))
  press('<C-o>')
  expect_file(linked .. '/start.txt')
  press("'A")
  expect_file(linked .. file)
  assert(vim.deep_equal(vim.api.nvim_win_get_cursor(0), { 4, 2 }))
  assert(vim.deep_equal(saved_mark, vim.api.nvim_get_mark('A', {})))

  press('mB')
  edit(main .. '/start.txt')
  press("'B")
  expect_file(main .. file)

  vim.cmd.enew()
  vim.cmd.lcd({ args = { linked } })
  press("'A")
  expect_file(linked .. file)

  edit(unrelated .. '/start.txt')
  press("'A")
  expect_file(main .. file)

  edit(linked .. '/start.txt')
  vim.fn.delete(linked .. file)
  local message, level
  local notify = vim.api.nvim_notify
  vim.api.nvim_notify = function(text, severity)
    message, level = text, severity
  end
  press("'A")
  vim.api.nvim_notify = notify
  expect_file(linked .. '/start.txt')
  assert(level == vim.log.levels.WARN and message:find('missing from this worktree', 1, true))
  assert(vim.deep_equal(saved_mark, vim.api.nvim_get_mark('A', {})))

  print('PASS: same-repository remapping, default behavior, cursor position, jump list, and missing files')
end, debug.traceback)

vim.go.shadafile = 'NONE'
vim.fn.delete(directory, 'rf')
assert(ok, err)
