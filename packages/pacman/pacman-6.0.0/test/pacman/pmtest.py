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
import shlex
import shutil
import stat
import subprocess
import threading
import time

import pmrule
import pmserve
import pmdb
import pmfile
import tap
import util
from util import vprint

class pmtest(object):
    """Test object
    """

    def __init__(self, name, root, config):
        self.name = name
        self.testname = os.path.basename(name).replace('.py', '')
        self.root = root
        self.dbver = 9
        self.cachepkgs = True
        self.config = config
        self.cmd = ["pacman", "--noconfirm",
                "--config", self.configfile(),
                "--root", self.rootdir(),
                "--dbpath", self.dbdir(),
                "--hookdir", self.hookdir(),
                "--cachedir", self.cachedir()]

        self.http_servers = []

    def __str__(self):
        return "name = %s\n" \
               "testname = %s\n" \
               "root = %s" % (self.name, self.testname, self.root)

    def addpkg2db(self, treename, pkg):
        if not treename in self.db:
            self.db[treename] = pmdb.pmdb(treename, self.root)
        self.db[treename].pkgs.append(pkg)

    def addpkg(self, pkg):
        self.localpkgs.append(pkg)

    def findpkg(self, name, version, allow_local=False):
        """Find a package object matching the name and version specified in
        either sync databases or the local package collection. The local database
        is allowed to match if allow_local is True."""
        for db in self.db.values():
            if db.is_local and not allow_local:
                continue
            pkg = db.getpkg(name)
            if pkg and pkg.version == version:
                return pkg
        for pkg in self.localpkgs:
            if pkg.name == name and pkg.version == version:
                return pkg

        return None

    def addrule(self, rulename):
        rule = pmrule.pmrule(rulename)
        self.rules.append(rule)

    def load(self):
        # Reset test parameters
        self.result = {
            "success": 0,
            "fail": 0
        }
        self.args = ""
        self.retcode = 0
        self.db = {
            "local": pmdb.pmdb("local", self.root)
        }
        self.localpkgs = []
        self.createlocalpkgs = False
        self.filesystem = []

        self.description = ""
        self.option = {}

        # Test rules
        self.rules = []
        self.files = []
        self.expectfailure = False
        self.skipall = False

        if os.path.isfile(self.name):
            # all tests expect this to be available
            from pmpkg import pmpkg
            with open(self.name) as input:
                exec(input.read(),locals())
        else:
            raise IOError("file %s does not exist!" % self.name)

    def generate(self, pacman):
        tap.diag("==> Generating test environment")

        # Cleanup leftover files from a previous test session
        if os.path.isdir(self.root):
            shutil.rmtree(self.root)
        vprint("\t%s" % self.root)

        # Create directory structure
        vprint("    Creating directory structure:")
        dbdir = os.path.join(self.root, util.PM_SYNCDBPATH)
        cachedir = os.path.join(self.root, util.PM_CACHEDIR)
        syncdir = os.path.join(self.root, util.SYNCREPO)
        tmpdir = os.path.join(self.root, util.TMPDIR)
        logdir = os.path.join(self.root, os.path.dirname(util.LOGFILE))
        etcdir = os.path.join(self.root, os.path.dirname(util.PACCONF))
        bindir = os.path.join(self.root, "bin")
        ldconfig = os.path.basename(pacman["ldconfig"])
        ldconfigdir = os.path.join(self.root, os.path.dirname(pacman["ldconfig"][1:]))
        shell = pacman["scriptlet-shell"][1:]
        shelldir = os.path.join(self.root, os.path.dirname(shell))
        sys_dirs = [dbdir, cachedir, syncdir, tmpdir, logdir, etcdir, bindir,
                    ldconfigdir, shelldir]
        for sys_dir in sys_dirs:
            if not os.path.isdir(sys_dir):
                vprint("\t%s" % sys_dir[len(self.root)+1:])
                os.makedirs(sys_dir, 0o755)
        # Only the dynamically linked binary is needed for fakechroot
        shutil.copy("/bin/sh", bindir)
        if shell != "bin/sh":
            shutil.copy("/bin/sh", os.path.join(self.root, shell))
        shutil.copy(os.path.join(util.SELFPATH, "ldconfig.stub"),
            os.path.join(ldconfigdir, ldconfig))
        ld_so_conf = open(os.path.join(etcdir, "ld.so.conf"), "w")
        ld_so_conf.close()

        # Configuration file
        vprint("    Creating configuration file")
        util.mkcfgfile(util.PACCONF, self.root, self.option, self.db)

        # Creating packages
        vprint("    Creating package archives")
        for pkg in self.localpkgs:
            vprint("\t%s" % os.path.join(util.TMPDIR, pkg.filename()))
            pkg.finalize()
            pkg.makepkg(tmpdir)
        for key, value in self.db.items():
            for pkg in value.pkgs:
                pkg.finalize()
            if key == "local" and not self.createlocalpkgs:
                continue
            for pkg in value.pkgs:
                vprint("\t%s" % os.path.join(util.PM_CACHEDIR, pkg.filename()))
                if self.cachepkgs:
                    pkg.makepkg(cachedir)
                elif value.syncdir:
                    pkg.makepkg(os.path.join(syncdir, value.treename))
                if pkg.path:
                    pkg.md5sum = util.getmd5sum(pkg.path)
                    pkg.csize = os.stat(pkg.path)[stat.ST_SIZE]

        # Creating sync database archives
        vprint("    Creating databases")
        for key, value in self.db.items():
            vprint("\t" + value.treename)
            value.generate()

        # Filesystem
        vprint("    Populating file system")
        for f in self.filesystem:
            if type(f) is pmfile.pmfile:
                vprint("\t%s" % f.path)
                f.mkfile(self.root);
            else:
                vprint("\t%s" % f)
                path = util.mkfile(self.root, f, f)
                if os.path.isfile(path):
                    os.utime(path, (355, 355))
        for pkg in self.db["local"].pkgs:
            vprint("\tinstalling %s" % pkg.fullname())
            pkg.install_package(self.root)
        if self.db["local"].pkgs and self.dbver >= 9:
            path = os.path.join(self.root, util.PM_DBPATH, "local")
            util.mkfile(path, "ALPM_DB_VERSION", str(self.dbver))

        # Done.
        vprint("    Taking a snapshot of the file system")
        for filename in self.snapshots_needed():
            f = pmfile.snapshot(self.root, filename)
            self.files.append(f)
            vprint("\t%s" % f.name)

    def require_capability(self, cap):
        if not self.config[cap]:
            self.skipall = "missing capability " + cap

    def add_hook(self, name, content):
        if not name.endswith(".hook"):
            name = name + ".hook"
        path = os.path.join("etc/pacman.d/hooks/", name)
        self.filesystem.append(pmfile.pmfile(path, content))

    def add_script(self, name, content):
        if not content.startswith("#!"):
            content = "#!/bin/sh\n" + content
        path = os.path.join("bin/", name)
        self.filesystem.append(pmfile.pmfile(path, content, mode=0o755))

    def snapshots_needed(self):
        files = set()
        for r in self.rules:
            files.update(r.snapshots_needed())
        return files

    def run(self, pacman):
        if os.path.isfile(util.PM_LOCK):
            tap.bail("\tERROR: another pacman session is on-going -- skipping")
            return

        tap.diag("==> Running test")
        vprint("\tpacman %s" % self.args)

        cmd = []
        if os.geteuid() != 0:
            fakeroot = util.which("fakeroot")
            if not fakeroot:
                tap.diag("WARNING: fakeroot not found!")
            else:
                cmd.append("fakeroot")

            fakechroot = util.which("fakechroot")
            if not fakechroot:
                tap.diag("WARNING: fakechroot not found!")
            else:
                cmd.append("fakechroot")

        if pacman["gdb"]:
            cmd.extend(["libtool", "execute", "gdb", "--args"])
        if pacman["valgrind"]:
            suppfile = os.path.join(os.path.dirname(__file__),
                    '..', '..', 'valgrind.supp')
            cmd.extend(["libtool", "execute", "valgrind", "-q",
                "--tool=memcheck", "--leak-check=full",
                "--show-reachable=yes",
                "--gen-suppressions=all",
                "--child-silent-after-fork=yes",
                "--log-file=%s" % os.path.join(self.root, "var/log/valgrind"),
                "--suppressions=%s" % suppfile])
            self.addrule("FILE_EMPTY=var/log/valgrind")

        # replace program name with absolute path
        prog = pacman["bin"]
        if not prog:
            prog = util.which(self.cmd[0], pacman["bindir"])
        if not prog or not os.access(prog, os.X_OK):
            if not prog:
                tap.bail("could not locate '%s' binary" % (self.cmd[0]))
                return

        cmd.append(os.path.abspath(prog))
        cmd.extend(self.cmd[1:])
        if pacman["manual-confirm"]:
            cmd.append("--confirm")
        if pacman["debug"]:
            cmd.append("--debug=%s" % pacman["debug"])
        cmd.extend(shlex.split(self.args))

        if not (pacman["gdb"] or pacman["nolog"]):
            output = open(os.path.join(self.root, util.LOGFILE), 'w')
        else:
            output = None
        vprint("\trunning: %s" % " ".join(cmd))

        self.start_http_servers()

        # Change to the tmp dir before running pacman, so that local package
        # archives are made available more easily.
        time_start = time.time()
        self.retcode = subprocess.call(cmd, stdout=output, stderr=output,
                cwd=os.path.join(self.root, util.TMPDIR), env={'LC_ALL': 'C'})
        time_end = time.time()
        vprint("\ttime elapsed: %.2fs" % (time_end - time_start))

        self.stop_http_servers()

        if output:
            output.close()

        vprint("\tretcode = %s" % self.retcode)

        # Check if the lock is still there
        if os.path.isfile(util.PM_LOCK):
            tap.diag("\tERROR: %s not removed" % util.PM_LOCK)
            os.unlink(util.PM_LOCK)
        # Look for a core file
        if os.path.isfile(os.path.join(self.root, util.TMPDIR, "core")):
            tap.diag("\tERROR: pacman dumped a core file")

    def check(self):
        tap.plan(len(self.rules))
        for i in self.rules:
            success = i.check(self)
            if success == 1:
                self.result["success"] += 1
            else:
                self.result["fail"] += 1
            tap.ok(success, i)

    def configfile(self):
        return os.path.join(self.root, util.PACCONF)

    def dbdir(self):
        return os.path.join(self.root, util.PM_DBPATH)

    def rootdir(self):
        return self.root + '/'

    def cachedir(self):
        return os.path.join(self.root, util.PM_CACHEDIR)

    def hookdir(self):
        return os.path.join(self.root, util.PM_HOOKDIR)

    def add_simple_http_server(self, responses):
        logfile = lambda h: open(os.path.join(self.root, 'var/log/httpd.log'), 'a')
        handler = type(self.name + 'HTTPServer',
                (pmserve.pmStringHTTPRequestHandler,),
                {'responses': responses, 'logfile': logfile})
        server = pmserve.pmHTTPServer(('127.0.0.1', 0), handler)
        self.http_servers.append(server)
        host, port = server.server_address[:2]
        return 'http://%s:%d' % (host, port)

    def start_http_servers(self):
        for srv in self.http_servers:
            thread = threading.Thread(target=srv.serve_forever)
            thread.daemon = True
            thread.start()

    def stop_http_servers(self):
        for srv in self.http_servers:
            srv.shutdown()
