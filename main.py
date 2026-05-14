#!/usr/bin/env python3
# main.py — minimal terminal IDE run loop
import curses
import os
import sys
import subprocess

import config as cfg
from browser import FileBrowser
from editor import Buffer
from ui import draw_browser, draw_cmdbar, draw_editor, draw_statusbar, setup_colors

CTRL = lambda c: ord(c.upper()) - 64
ESC  = 27

class LiteIDE:
    def __init__(self, stdscr, target_path):
        self.stdscr = stdscr
        self.buffers = []
        self.buf_idx = 0
        self.show_browser = True
        self.focus_editor = True
        self.status_message = "Welcome! Tab: Switch Panel | Ctrl+Q: Quit"

        target = target_path if target_path else "."
        if os.path.isdir(target):
            self.browser = FileBrowser(target)
            self.buffers.append(Buffer())
        else:
            self.browser = FileBrowser(os.path.dirname(os.path.abspath(target)) or ".")
            self.buffers.append(Buffer(target))

        setup_colors()
        curses.curs_set(1)
        self.stdscr.keypad(True)
        self.resize_windows()

    def resize_windows(self):
        self.stdscr.erase()
        h, w = self.stdscr.getmaxyx()
        b_width = cfg.DEFAULTS.get("browser_width", 22) if self.show_browser else 0
        e_width = w - b_width

        if h < 4 or e_width < 5: return

        self.win_browser = curses.newwin(h - 2, b_width, 0, 0) if self.show_browser else None
        self.win_editor  = curses.newwin(h - 2, e_width, 0, b_width)
        self.win_status  = curses.newwin(1, w, h - 2, 0)
        self.win_cmdbar  = curses.newwin(1, w, h - 1, 0)

    def current_buf(self):
        return self.buffers[self.buf_idx]

    def input_prompt(self, prompt):
        curses.curs_set(1)
        val = ""
        while True:
            draw_cmdbar(self.win_cmdbar, self.stdscr.getmaxyx(), prompt, val)
            self.win_cmdbar.refresh()
            ch = self.win_cmdbar.getch()
            if ch in (10, 13, curses.KEY_ENTER): return val
            elif ch == ESC: return None
            elif ch in (curses.KEY_BACKSPACE, 127, 8): val = val[:-1]
            elif 32 <= ch <= 126: val += chr(ch)

    def run_file(self):
        buf = self.current_buf()
        if not buf.path or not buf.path.endswith(".py"):
            self.status_message = "Error: F5 only runs Python (.py) files."
            return
        if buf.modified: buf.save()
        curses.def_shell_mode()
        self.stdscr.clear()
        self.stdscr.refresh()
        print(f"\n--- Running {os.path.basename(buf.path)} ---")
        subprocess.run([sys.executable, buf.path])
        input("\nPress [Enter] to return...")
        curses.reset_shell_mode()
        self.resize_windows()

    def handle_key(self, ch):
        buf = self.current_buf()
        if ch == 9:
            self.focus_editor = not self.focus_editor
            return
        elif ch == CTRL('t'):
            self.show_browser = not self.show_browser
            self.resize_windows()
            return

        if self.focus_editor:
            if ch == curses.KEY_UP:    buf.move(dy=-1)
            elif ch == curses.KEY_DOWN:  buf.move(dy=1)
            elif ch == curses.KEY_LEFT:  buf.move(dx=-1)
            elif ch == curses.KEY_RIGHT: buf.move(dx=1)
            elif ch in (curses.KEY_BACKSPACE, 127, 8): buf.backspace()
            elif ch in (10, 13, curses.KEY_ENTER): buf.insert_newline()
            elif ch == CTRL('d'): buf.delete_line()
            elif ch == CTRL('z'): buf.undo()
            elif ch == CTRL('s'): buf.save()
            elif ch == CTRL('w'):
                p = self.input_prompt("Save As: ")
                if p: buf.save(p)
            elif ch == curses.KEY_F5: self.run_file()
            elif 32 <= ch <= 126: buf.insert_char(chr(ch))
        else:
            if ch == curses.KEY_UP: self.browser.move_up()
            elif ch == curses.KEY_DOWN: self.browser.move_down()
            elif ch in (10, 13, curses.KEY_ENTER, 32):
                p = self.browser.toggle_selected()
                if p:
                    self.buffers.append(Buffer(p))
                    self.buf_idx = len(self.buffers) - 1
                    self.focus_editor = True

    def loop(self):
        while True:
            h, w = self.stdscr.getmaxyx()
            buf = self.current_buf()

            if self.show_browser and self.win_browser:
                bh, bw = self.win_browser.getmaxyx()
                draw_browser(self.win_browser, self.browser, bh, bw)
                self.win_browser.refresh()

            eh, ew = self.win_editor.getmaxyx()
            draw_editor(self.win_editor, buf, eh, ew, show_line_nums=cfg.DEFAULTS["show_line_numbers"])
            
            if self.focus_editor:
                lnw = len(str(len(buf.lines))) + 2 if cfg.DEFAULTS["show_line_numbers"] else 0
                cy_s, cx_s = buf.cy - buf.scroll_y, lnw + (buf.cx - buf.scroll_x)
                if 0 <= cy_s < eh and lnw <= cx_s < ew: self.win_editor.move(cy_s, cx_s)

            self.win_editor.refresh()
            draw_statusbar(self.win_status, buf, w, self.status_message)
            self.win_status.refresh()
            draw_cmdbar(self.win_cmdbar, w, hint="Tab: Focus | Ctrl+Q: Quit")
            self.win_cmdbar.refresh()

            ch = self.win_editor.getch() if self.focus_editor else self.win_browser.getch()
            if ch == CTRL('q'): break
            self.handle_key(ch)

if __name__ == "__main__":
    target_arg = sys.argv[1] if len(sys.argv) > 1 else None
    curses.wrapper(lambda stdscr: LiteIDE(stdscr, target_arg).loop())
