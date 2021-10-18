#  Copyright (c) 2006 by Aurelien Foret <orelien@chez.com>
#  Copyright (c) 2006-2021 Pacman Development Team <pacman-dev@archlinux.org>
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


import os

import pmtest
import tap


class pmenv(object):
    """Environment object
    """
    testcases = []

    def __init__(self, root = "root"):
        self.root = os.path.abspath(root)
        self.pacman = {
            "bin": None,
            "bindir": ["/usr/bin/"],
            "debug": 0,
            "gdb": 0,
            "valgrind": 0,
            "nolog": 0
        }
        self.config = {
            "gpg": True,
            "nls": True,
            "curl": True
        }

    def __str__(self):
        return "root = %s\n" \
               "pacman = %s" \
               % (self.root, self.pacman)

    def addtest(self, testcase):
        """
        """
        if not os.path.isfile(testcase):
            raise IOError("test file %s not found" % testcase)
        self.testcases.append(testcase)

    def run(self):
        """
        """
        for testcase in self.testcases:
            t = pmtest.pmtest(testcase, self.root, self.config)
            t.load()
            if t.skipall:
                tap.skip_all("skipping %s (%s)" % (t.description, t.skipall))
            else:
                tap.plan(1)
                tap.diag("Running '%s'" % t.testname)

                t.generate(self.pacman)
                t.run(self.pacman)

                tap.diag("==> Checking rules")
                # When running under meson, we don't emit 'todo' in the plan and instead
                # handle expected failures in the test() objects. This really should be
                # fixed in meson:
                # https://github.com/mesonbuild/meson/issues/2923#issuecomment-614647076
                tap.todo = (t.expectfailure and
                        not 'RUNNING_UNDER_MESON' in os.environ)
                tap.subtest(lambda: t.check(), t.description)
