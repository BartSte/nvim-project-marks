# README - nvim-project-marks

Minimal Neovim plugin to set file marks for specific projects.

# CONTENTS

<!--toc:start-->
- [Introduction](#introduction)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
  - [Locally](#locally)
  - [Grouped](#grouped)
- [Commands](#commands)
- [Functions](#functions)
- [Lualine](#lualine)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)
<!--toc:end-->

# Introduction

Using file marks is a great way to quickly jump to a specific file. By "file
marks" I mean the marks you set on using `m` and a capital or a number (see `:h
mark-motions`). Many great plugins exist that leverage similar strategies to
jump between files, like [harpoon](https://github.com/ThePrimeagen/harpoon).
However, I wanted a simpler plugin that does only the following things:

- Set marks that only a apply to a specific project.
- After jumping to a mark, jump to the last cursor position in that file.

That's it, nothing more.

Well, some extra features are added later that are nice, but not essential.

# Installation

Use your favorite plugin manager. For example lazy.nvim:

```lua
return {
    'BartSte/nvim-project-marks',
    lazy = false,
    config = function()
        require('projectmarks').setup({})
    end
}
```

Lazy loading is not recommended, as the plugin may need to load another shada
file than the global one. By lazy loading the plugin, this will go wrong. Note
that the plugin is very small, so it will not slow down your startup time
noticeably.

# Configuration

The following configuration are the default and can be changed through the
`require("projectmarks").setup` function:

```lua
require('projectmarks').setup({
  -- Set Neovim's shadafile to the given value, if it can be found by moving up
  -- the directory tree. If not, the global shada file is used.
  shadafile = 'nvim.shada',

  -- If set to true, the following happens:
  -- - The mapping "'" is appended by the `LastPosition` command.
  -- - The mapping "`" is appended by the `LastColumnPosition` command.
  -- - The `m` key, the `:mark` command, and the `:delmark` command are appended
  --   by a function that refreshes the lualine statusline. If you do not use
  --   this feature, nothing will happen.
  mappings = true,

  -- Message to be displayed when jumping to a mark.
  message = 'Waiting for mark...'
})
```

# Usage

Typically, there are two strategies to manage your shada file. Locally, and
grouped. The following sections explain the difference.

## Locally

To set marks for specific project, you need create an empty file at the value of
`require("projectmarks").opts.shadafile`. You can do this manually, or
you can call `:MakeShada`. This file will keep track of the marks you set for
that project. After this, you can set marks like you normally would as is
described in `:h mark-motions`.

For example:

- You have your projects stored in the directory: `~/code`
- Lets say you have the following projects:
  - `~/code/project_1/file.lua`
  - `~/code/project_2/file.lua`
- For each project you will have `nvim.shada` file:
  - `~/code/project_1/nvim.shada`
  - `~/code/project_2/nvim.shada`
- Also, you add a shada file to `~/code/nvim.shada`.
- When you cd into `~/code/project_1` and open `file.lua`, the
  `~/code/project_1/nvim.shada` will be used.
- When you cd into `~/code/project_2` and open `file.lua`, the
  `~/code/project_2/nvim.shada` will be used.
- When you cd into `~/code` and open `~/code/project_1/file.lua`, the
  `~/code/nvim.shada` will be used.
- When you cd into `~` and open `~/code/project_1/file.lua`, the global shada
  will be used as there is no shada file in `~`.

## Grouped

This method avoids creating shada files in each project (which you have to add
to your `.gitignore` file). Instead, you can group your shada files in a
specific directory. For example:

- Create a directory, lets call it `~/shadas`.
- Place the following in your config:

```lua
-- Get the name of the current working directory.
local function cwd_name()
  return vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
end

require('projectmarks').setup({
  shadafile = "~/shadas/" .. cwd_name() .. ".shada"
})
```

- When you create a new project, create a new empty shada file in `~/shadas`
  with the name of root directory of the project. For example, if your project
  is stored in `~/code/project_1`, create a file called
  `~/shadas/project_1.shada`. You can do this manually, or you can call
  `:MakeShada`.

Now, each time you open Neovim from the root of a project, the plugin will look
for a shada file in `~/shadas` with the name of the root directory of the
project. If it finds one, it will use that file. If it does not find one, it
will use the global shada file of Neovim.

# Commands

The following commands are exposed:

- `MakeShada`: Create a new shada file at the path that is set in the `shadafile`
  option.
- `AddMark`: The same as the `m` key and the `:mark` command, but also refreshes
  the lualine statusline.
- `DeleteMark`: The same as the `:delmark` command, but also refreshes the
  lualine statusline.
- `LastPosition`: Jump to the last position in the file of the given mark.
- `LastColumnPosition`: Jump to the last column position in the file of the
  given mark.

# Functions

The following functions are exposed through the `require("projectmarks")`
module.

- `jump_with`: When using a global mark, the following will be appended to the
  command: {symbol}". For example, if we set symbol to `symbol='`, after calling
  a global mark `A`, the following command is triggered: `'A'"` As, a result the
  cursor is returned to the last position ('") instead of the mark. As a result,
  you will jump to the last position in the file of the given mark.
- The functions: `make_shada`, `add_mark`, `delete_mark`, `last_position`, and
  `last_column_position` are also exposed. They are equivalent to the commands,
  only now no notifications are displayed.

It is not recommended to use functions from other modules, as they are may be
subject to change, with the exception of the `require("projectmarks").lualine`
module, as is explained in the next section.

# Lualine

For those using lualine, the following tables can be used for lualine:

- `require('projectmarks').lualine.shada`: Displays an icon with the name of the
  shada file that is being used. If the global shada file is used, nothing is
  displayed.
- `require('projectmarks').lualine.marks`: Displays the marks that are set in
  the current buffer. If no marks are set, nothing is displayed.
- `require('projectmarks').lualine.marks_optimized`: Has the same functionality
  as `marks`, but it only refreshes its content when the active buffer changes,
  or the marks are changed. The `opts.mapping` option must be set to `true` for
  this to work.

# Troubleshooting

If you encounter any issues, please report them on the issue tracker at:
[nvim-project-marks issues](https://github.com/BartSte/nvim-project-marks/issues)

# Contributing

Contributions are welcome! Please see [CONTRIBUTING](./CONTRIBUTING.md) for
more information.

# License

Distributed under the MIT License.
