# Changelog - nvim-project-marks

This document describes the changes that were made to the software for each
version. The changes are described concisely, to make it comprehensible for the
user. A change is always categorized based on the following types:

- Bug: a fault in the software is fixed.
- Feature: a functionality is added to the program.
- Improvement: a functionality in the software is improved.
- Task: a change is made to the repository that has no effect on the source
  code.

# 0.2.0

- Added lualine support for shada and marks for the current file.
- Added an optimization for lualine were the marks are only updated when they 
  are changed by the user. As a part of this, the use must use `:Mark` instead
  of `:mark` and `:DelMarks` instead of `:delmarks`. Doing so is facilitated by
  providing the `abbreviations` option in the configuration.

# 0.1.0

- Added the MakeShada command

# 0.0.2

- bugfix: notification presisted after selecting mark

# 0.0.1

- bugfix: vim help docs were not generated correctly

# 0.0.0

- Marks can jump to the last cursor position in that file.
- Marks can be set for a specific project.
