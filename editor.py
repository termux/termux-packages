# editor.py — text buffer + cursor management
import os
import re
import copy

class Buffer:
    """
    Holds the full content of one open file plus all editing state.
    Every mutating method pushes onto the undo stack before making changes.
    """
    def __init__(self, path=None):
        self.path = path
        self.lines = [""]        # at least one line, always
        self.cx = 0              # cursor column
        self.cy = 0              # cursor row
        self.scroll_x = 0
        self.scroll_y = 0
        self.modified = False
        self.encoding = "utf-8"
        self._undo_stack = []
        self._redo_stack = []

        if path and os.path.isfile(path):
            self._load(path)

    @property
    def name(self):
        return os.path.basename(self.path) if self.path else "[No Name]"

    def _load(self, path):
        """Try a few encodings so we don't explode on latin-1 files."""
        content = ""
        for enc in ("utf-8", "latin-1", "cp1252"):
            try:
                with open(path, "r", encoding=enc) as fh:
                    content = fh.read()
                self.encoding = enc
                break
            except (UnicodeDecodeError, PermissionError):
                continue

        self.lines = content.splitlines()
        if not self.lines:
            self.lines = [""]
        if content.endswith("\n") and self.lines[-1] == "":
            self.lines.pop()
        if not self.lines:
            self.lines = [""]
        self.modified = False

    def save(self, path=None):
        path = path or self.path
        if not path:
            return False
        try:
            content = "\n".join(self.lines) + "\n"
            with open(path, "w", encoding=self.encoding) as fh:
                fh.write(content)
            self.path = path
            self.modified = False
            return True
        except OSError:
            return False

    def current_line(self):
        return self.lines[self.cy]

    def move(self, dy=0, dx=0):
        self.cy = max(0, min(self.cy + dy, len(self.lines) - 1))
        self.cx = max(0, min(self.cx + dx, len(self.current_line())))

    def move_to(self, row, col=0):
        self.cy = max(0, min(row, len(self.lines) - 1))
        self.cx = max(0, min(col, len(self.current_line())))

    def move_home(self):
        """Jump to first non-whitespace, then to column 0 on a second press."""
        line = self.current_line()
        first_nonws = len(line) - len(line.lstrip())
        self.cx = 0 if self.cx == first_nonws else first_nonws

    def move_end(self):
        self.cx = len(self.current_line())

    def _push_undo(self):
        self._undo_stack.append((copy.copy(self.lines), self.cy, self.cx))
        self._redo_stack.clear()
        if len(self._undo_stack) > 300:
            self._undo_stack.pop(0)

    def undo(self):
        if not self._undo_stack:
            return
        self._redo_stack.append((list(self.lines), self.cy, self.cx))
        lines, cy, cx = self._undo_stack.pop()
        self.lines = lines
        self.cy, self.cx = cy, cx
        self.modified = True

    def redo(self):
        if not self._redo_stack:
            return
        self._undo_stack.append((list(self.lines), self.cy, self.cx))
        lines, cy, cx = self._redo_stack.pop()
        self.lines = lines
        self.cy, self.cx = cy, cx
        self.modified = True

    def insert_char(self, ch):
        self._push_undo()
        line = self.lines[self.cy]
        self.lines[self.cy] = line[: self.cx] + ch + line[self.cx :]
        self.cx += 1
        self.modified = True

    def insert_newline(self, tab_size=4, auto_indent=True):
        self._push_undo()
        line = self.lines[self.cy]

        indent = ""
        if auto_indent:
            indent = re.match(r"^(\s*)", line).group(1)
            if line.rstrip().endswith((":", "{", "[")):
                indent += " " * tab_size

        rest = line[self.cx :]
        self.lines[self.cy] = line[: self.cx]
        self.cy += 1
        self.lines.insert(self.cy, indent + rest)
        self.cx = len(indent)
        self.modified = True

    def backspace(self):
        if self.cx > 0:
            self._push_undo()
            line = self.lines[self.cy]
            self.lines[self.cy] = line[: self.cx - 1] + line[self.cx :]
            self.cx -= 1
            self.modified = True
        elif self.cy > 0:
            self._push_undo()
            prev = self.lines[self.cy - 1]
            self.cx = len(prev)
            self.lines[self.cy - 1] = prev + self.lines[self.cy]
            self.lines.pop(self.cy)
            self.cy -= 1
            self.modified = True

    def delete_line(self):
        self._push_undo()
        if len(self.lines) > 1:
            self.lines.pop(self.cy)
            self.cy = min(self.cy, len(self.lines) - 1)
        else:
            self.lines[0] = ""
        self.cx = 0
        self.modified = True

    def clamp_scroll(self, view_rows, view_cols, gutter_width=0):
        if self.cy < self.scroll_y:
            self.scroll_y = self.cy
        elif self.cy >= self.scroll_y + view_rows:
            self.scroll_y = self.cy - view_rows + 1

        effective_cx = self.cx + gutter_width
        if effective_cx < self.scroll_x:
            self.scroll_x = effective_cx
        elif effective_cx >= self.scroll_x + view_cols:
            self.scroll_x = effective_cx - view_cols + 1

    def find(self, query, wrap=True):
        if not query:
            return None
        total = len(self.lines)
        for i in range(total):
            row = (self.cy + i) % total
            start_col = (self.cx + 1) if i == 0 else 0
            idx = self.lines[row].find(query, start_col)
            if idx != -1:
                return row, idx
        return None
