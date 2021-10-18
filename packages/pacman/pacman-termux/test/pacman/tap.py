#  Copyright (c) 2013-2021 Pacman Development Team <pacman-dev@archlinux.org>
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.

todo = None
count = 0
level = 0
failed = 0

def _output(msg):
    leader = "#" if level > 0 else ""
    print("%s%s%s" % (leader, "    "*level, str(msg).replace("\n", "\\n")))

def skip_all(description=""):
    if description:
        description = " # " + description
    _output("1..0%s" % (description))

def ok(ok, description=""):
    global count, failed
    count += 1
    if not ok:
        failed += 1
    directive = " # TODO" if todo else ""
    _output("%s %d - %s%s" % ("ok" if ok else "not ok", count,
        description, directive))

def plan(count):
    _output("1..%d" % (count))

def diag(msg):
    _output("# %s" % (msg))

def bail(reason=""):
    _output("Bail out! %s" % (reason))

def subtest(func, description=""):
    global todo, count, level, failed

    save_todo = todo
    save_count = count
    save_level = level
    save_failed = failed

    todo = None
    count = 0
    level += 1
    failed = 0

    func()

    subtest_ok = not failed

    todo = save_todo
    count = save_count
    level = save_level
    failed = save_failed

    ok(subtest_ok, description)
