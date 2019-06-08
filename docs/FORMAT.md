# Formatting Guidelines

All files should adhere to these formatting guidelines.

## Shell Script Formatting

- All `build.sh` files should be set to `644` permission.

- All scripts should use tabs rather than spaces.

- All parantheses of shell functions should not be preceded with a space.

- Avoid trailing spaces and tabs.

- Avoid usage of non UTF-8 encoding.

- Comments should be compact. Do not tab them if not necessary.

## Shell Script Coding Practices

- Do not define global scope variables if not necessary.

- Do not export variables if not necessary.

- Custom variables in build.sh scripts should be defined inside functions.
  If you need a "global scope" variable at build time, just define it in
  `termux_step_pre_configure()`. If you still need to define variable outside
  of function, make sure that it does not use command or process substitution.

- Dollar parentheses `$()` rather than backticks ``` `` ``` should be employed
  in command substitution.

- Usage of `sudo` or `su` in build scripts is disallowed.

- Utility `install` is preferred over `cp` as the file installation program.

- Do not hardcode version numbers. Instead, use the `$TERMUX_PKG_VERSION` and
  `$TERMUX_PKG_REVISION` variables.

- Do not hardcode Termux prefix directory. Instead, use the `$TERMUX_PREFIX`
  variable.

- Do not hardcode Termux home directory. Instead, use the `$TERMUX_ANDROID_HOME`
  variable.

## Markdown Formatting

- All `filenames` should be under code formatting, unless they are links.

- All titles should be indented with hashes rather than equal signs.

- All unnumbered lists should be indented with hyphens.

- All Markdown should be edited on alternate line.

- All Markdown should use tabs rather than spaces.

- All `.md` should be set to `644` permission.

- All special characters should be escaped.

- All names of `.md` should be capitalised.

- All code blocks should be enclosed in backticks, with language specified.

- Lines shouldn't be longer than 80 characters.
