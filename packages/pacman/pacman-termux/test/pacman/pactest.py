#! /usr/bin/python3
#
#  pactest : run automated testing on the pacman binary
#
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

from optparse import OptionParser
import os
import shutil
import sys
import tempfile
import glob
import subprocess

import pmenv
import tap
import util

__author__ = "Aurelien FORET"
__version__ = "0.4"

# writer to send output to multiple destinations simultaneously
class MultiWriter():
    def __init__(self, *outputs):
        self.outputs = outputs

    def write(self, message):
        for op in self.outputs:
            op.write(message)

# duplicate stdout/stderr to a temporary file
class OutputSaver():
    def __init__(self):
        self.save_file = tempfile.NamedTemporaryFile(
                prefix='pactest-output-', mode='w')

    def __enter__(self):
        sys.stdout = MultiWriter(sys.stdout, self.save_file)
        sys.stderr = MultiWriter(sys.stderr, self.save_file)
        return self.save_file

    def __exit__(self, type, value, traceback):
        sys.stdout = sys.__stdout__
        sys.stderr = sys.__stderr__
        self.save_file.flush()

def create_parser():
    usage = "usage: %prog [options] <path/to/testfile.py>..."
    description = "Runs automated tests on the pacman binary. Tests are " \
            "described using an easy python syntax, and several can be " \
            "ran at once."
    parser = OptionParser(usage = usage, description = description)

    parser.add_option("-v", "--verbose", action = "count",
                      dest = "verbose", default = 0,
                      help = "print verbose output")
    parser.add_option("-d", "--debug", type = "int",
                      dest = "debug", default = 0,
                      help = "set debug level for pacman")
    parser.add_option("-p", "--pacman", type = "string",
                      dest = "bin", default = None,
                      help = "specify location of the pacman binary")
    parser.add_option("--bindir", type = "string",
                      dest = "bindir", action = "append",
                      help = "specify location of binaries")
    parser.add_option("--without-gpg", action = "store_true",
                      dest = "missing_gpg", default = False,
                      help = "skip gpg-related tests")
    parser.add_option("--without-curl", action = "store_true",
                      dest = "missing_curl", default = False,
                      help = "skip downloader-related tests")
    parser.add_option("--without-nls", action = "store_true",
                      dest = "missing_nls", default = False,
                      help = "skip translation-related tests")
    parser.add_option("--keep-root", action = "store_true",
                      dest = "keeproot", default = False,
                      help = "don't remove the generated pacman root filesystem")
    parser.add_option("--nolog", action = "store_true",
                      dest = "nolog", default = False,
                      help = "do not log pacman messages")
    parser.add_option("--gdb", action = "store_true",
                      dest = "gdb", default = False,
                      help = "use gdb while calling pacman")
    parser.add_option("--valgrind", action = "store_true",
                      dest = "valgrind", default = os.getenv('PACTEST_VALGRIND'),
                      help = "use valgrind while calling pacman")
    parser.add_option("--manual-confirm", action = "store_true",
                      dest = "manualconfirm", default = False,
                      help = "do not use --noconfirm for pacman calls")
    parser.add_option("--scriptlet-shell", type = "string",
                      dest = "scriptletshell", default = "/bin/sh",
                      help = "specify path to shell used for install scriptlets")
    parser.add_option("--ldconfig", type = "string",
                      dest = "ldconfig", default = "/sbin/ldconfig",
                      help = "specify path to ldconfig")
    parser.add_option("--review", action = "store_true",
                      dest = "review", default = False,
                      help = "review test files, test output, and saved logs")
    parser.add_option("--editor", action = "store",
                      dest = "editor", default = os.getenv('EDITOR', 'vim'),
                      help = "editor to use for viewing files")
    return parser


if __name__ == "__main__":

    if sys.hexversion < 0x02070000:
        # bailing now with clear message better than mid-run with unhelpful one
        tap.bail("Python versions before 2.7 are not supported.")
        sys.exit(1)

    # parse options
    opt_parser = create_parser()
    (opts, args) = opt_parser.parse_args(args=os.getenv('PACTEST_OPTS', '').split())
    (opts, args) = opt_parser.parse_args(values=opts)

    if args is None or len(args) == 0:
        tap.bail("no tests defined, nothing to do")
        sys.exit(2)

    # instantiate env
    root_path = tempfile.mkdtemp(prefix='pactest-')
    env = pmenv.pmenv(root=root_path)

    # add parsed options to env object
    util.verbose = opts.verbose
    env.pacman["debug"] = opts.debug
    env.pacman["bin"] = opts.bin
    env.pacman["bindir"] = opts.bindir
    env.pacman["nolog"] = opts.nolog
    env.pacman["gdb"] = opts.gdb
    env.pacman["valgrind"] = opts.valgrind
    env.pacman["manual-confirm"] = opts.manualconfirm
    env.pacman["scriptlet-shell"] = opts.scriptletshell
    env.pacman["ldconfig"] = opts.ldconfig
    env.config["gpg"] = not opts.missing_gpg
    env.config["nls"] = not opts.missing_nls
    env.config["curl"] = not opts.missing_curl

    try:
        for i in args:
            env.addtest(i)
    except Exception as e:
        tap.bail(e)
        os.rmdir(root_path)
        sys.exit(2)

    # run tests
    if not opts.review:
        env.run()
    else:
        # save output in tempfile for review
        with OutputSaver() as save_file:
            env.run()
        files = [save_file.name] + args + glob.glob(root_path + "/var/log/*")
        subprocess.call([opts.editor] + files)

    if not opts.keeproot:
        shutil.rmtree(root_path)
    else:
        tap.diag("pacman testing root saved: %s" % root_path)
