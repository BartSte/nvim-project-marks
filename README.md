# README - nvim-project-marks

Minimal Neovim plugin to set file marks for specific projects.

## CONTENTS

1. [Introduction](#introduction)
2. [Installation](#installation)
3. [Configuration](#configuration)
4. [Usage](#usage)
5. [Functions](#functions)
6. [Troubleshooting](#troubleshooting)
7. [Contributing](#contributing)
8. [License](#license)

## Introduction

Using file marks is a great way to quickly jump to a specific file. By "file
marks" I mean the marks you set on using `m` and a capital or a number (see `:h
mark-motions`). Many great plugins exist that leverage similar strategies to
jump between files, like [harpoon](https://github.com/ThePrimeagen/harpoon).
However, I wanted a simpler plugin that does only the following things:

- Set marks that only a apply to a specific project.
- After jumping to a mark, jump to the last cursor position in that file.
  
That's it, nothing more.

## Installation

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

Lazy loading is not recommended, as the plugin may need to load another shada file than the global one. By lazy loading the plugin, this will go wrong. Note that the plugin is very small, so it will not slow down your startup time.

## Configuration

The following configuration are the default and can be changed through the
`projectmarks.setup` function:

```lua
require('projectmarks').setup({
  -- If set to a string, the path to the shada file is set to the given value.
  -- If set to a boolean, the global shada file of neovim is used.
  shadafile = 'nvim.shada',

  -- If set to true, the "'" and "`" mappings are are appended by the
  -- `last_position`, and `last_column_position` functions, respectively.
  mappings = true,

  -- Message to be displayed when jumping to a mark.
  message = 'Waiting for mark...'
})
```

## Usage

To set marks for specific projects, you need create an empty file called
`nvim.shada` (or whatever you set `shadafile` option to) in the root of your
project. This file will keep track of the marks you set for that project. If no
`nvim.shada` file is found, Neovim will transverse the directory tree upward,
until it finds one. If no `nvim.shada` file is found, the global shada file of
Neovim is used. After this, you can set marks like you normally would as is
described in `:h mark-motions`.

> For example:
>
> - You have your projects stored in the directory: `~/code`
> - Lets say you have the following projects:
>   - `~/code/project_1/file.lua`
>   - `~/code/project_2/file.lua`
> - For each project you will have `nvim.shada` file:
>   - `~/code/project_1/nvim.shada`
>   - `~/code/project_2/nvim.shada`
> - Also, you add a shada file to `~/code/nvim.shada`.
> - When you cd into `~/code/project_1` and open `file.lua`, the
>   `~/code/project_1/nvim.shada` will be used.
> - When you cd into `~/code/project_2` and open `file.lua`, the
>   `~/code/project_2/nvim.shada` will be used.
> - When you cd into `~/code` and open `~/code/project_1/file.lua`, the
>   `~/code/nvim.shada` will be used.
> - When you cd into `~` and open `~/code/project_1/file.lua`, the global shada
>   will be used as there is no shada file in `~`.

## Functions

The following functions are exposed:

- `last_position`: Jump to the last position in the file of the given mark.
- `last_column_position`: Jump to the last column position in the file of the
  given mark.
- `jump_with`: When using a global mark, the following will be appended to the
  command: {symbol}". For example, if we set symbol to `symbol='`, after calling
  a global mark `A`, the following command is triggered: `'A'"` As, a result the
  cursor is returned to the last position ('") instead of the mark. As a result,
  you will jump to the last position in the file of the given mark.

## Troubleshooting

If you encounter any issues, please report them on the issue tracker at:
[nvim-project-marks issues](https://github.com/BartSte/nvim-project-marks/issues)

## Contributing

Contributions are welcome! Please see [CONTRIBUTING](./CONTRIBUTING.md) for
more information.

## License

Distributed under the MIT License.
