# config.py — user-tunable settings for lite-ide

DEFAULTS = {
    "tab_size":         4,
    "expand_tabs":      True,       # insert spaces instead of \t
    "show_line_numbers": True,
    "syntax_highlight": False,      # set to False unless pygments tool is installed
    "browser_width":    22,         # left panel width in columns
    "theme":            "monokai",  # placeholder style name
    "auto_indent":      True,       # carry leading whitespace to new lines
    "trailing_newline": True,       # always end saved files with \n
}

# Friendly reminder of what each Ctrl-key does.
KEYBINDS = {
    "Ctrl+Q": "quit / close buffer",
    "Ctrl+S": "save",
    "Ctrl+W": "save as",
    "Ctrl+O": "open file",
    "Ctrl+N": "new buffer",
    "Ctrl+F": "find",
    "Ctrl+G": "go to line",
    "Ctrl+T": "toggle file browser",
    "Ctrl+Z": "undo",
    "Ctrl+Y": "redo",
    "Ctrl+D": "delete current line",
    "F5":     "run file (Python only)",
    "Tab":    "switch focus editor ↔ browser",
}
