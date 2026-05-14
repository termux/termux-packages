# config.py — user-tunable settings for lite-ide
DEFAULTS = {
    "tab_size":         4,
    "expand_tabs":      True,       
    "show_line_numbers": True,
    "syntax_highlight": False,      
    "browser_width":    22,         
    "theme":            "monokai",  
    "auto_indent":      True,       
    "trailing_newline": True,       
}

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
