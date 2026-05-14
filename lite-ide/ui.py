# ui.py — curses rendering for every panel
import curses
import os

P_DEFAULT   = 0
P_STATUS    = 9
P_TREE_DIR  = 10
P_TREE_SEL  = 11
P_LINENUM   = 12

def setup_colors():
    curses.start_color()
    curses.use_default_colors()
    bg = -1
    curses.init_pair(P_STATUS,   curses.COLOR_BLACK,   curses.COLOR_WHITE)
    curses.init_pair(P_TREE_DIR, curses.COLOR_CYAN,    bg)
    curses.init_pair(P_TREE_SEL, curses.COLOR_BLACK,   curses.COLOR_CYAN)
    curses.init_pair(P_LINENUM,  curses.COLOR_WHITE,   bg)

def _put(win, y, x, text, attr=0):
    try:
        win.addstr(y, x, text, attr)
    except curses.error:
        pass

def draw_browser(win, browser, height, width):
    win.erase()
    header = " FILES".ljust(width)
    _put(win, 0, 0, header[:width], curses.color_pair(P_STATUS))
    rows = browser.render(height - 1)
    for i, (text, selected, is_dir) in enumerate(rows):
        y = i + 1
        if y >= height: break
        text = text[:width].ljust(width)
        attr = curses.color_pair(P_TREE_SEL) if selected else (curses.color_pair(P_TREE_DIR) if is_dir else 0)
        _put(win, y, 0, text, attr)

def draw_editor(win, buf, height, width, show_line_nums=True):
    win.erase()
    total_lines = len(buf.lines)
    lnw = len(str(total_lines)) + 2 if show_line_nums else 0
    view_cols = width - lnw
    buf.clamp_scroll(height, view_cols, lnw)

    for row in range(height):
        lineno = buf.scroll_y + row
        if lineno >= total_lines: break
        line = buf.lines[lineno]

        if show_line_nums:
            gutter = str(lineno + 1).rjust(lnw - 1) + " "
            _put(win, row, 0, gutter, curses.color_pair(P_LINENUM) | curses.A_DIM)

        visible = line[buf.scroll_x : buf.scroll_x + view_cols]
        _put(win, row, lnw, visible)

def draw_statusbar(win, buf, width, message=""):
    win.erase()
    flag = " * " if buf.modified else "   "
    name = buf.name + flag
    pos  = f"Ln {buf.cy + 1}  Col {buf.cx + 1}"
    lang = os.path.splitext(buf.path or "").lstrip(".").upper() or "TXT"

    left  = f"  {name}|  {lang}  "
    right = f"  {pos}  "
    space = width - len(left) - len(right)
    mid_part = message[:space].center(space) if space > 4 else ""
    bar = (left + mid_part + right)[:width].ljust(width)
    _put(win, 0, 0, bar, curses.color_pair(P_STATUS))

def draw_cmdbar(win, width, prompt="", value="", hint=""):
    win.erase()
    if prompt or value:
        _put(win, 0, 0, (prompt + value)[:width])
    else:
        _put(win, 0, 0, hint[:width], curses.A_DIM)
