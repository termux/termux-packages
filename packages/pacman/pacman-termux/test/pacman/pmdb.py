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


from io import BytesIO
import os
import shutil
import tarfile

import pmpkg
import tap
import util

def _getsection(fd):
    i = []
    while 1:
        line = fd.readline().strip("\n")
        if not line:
            break
        i.append(line)
    return i

def make_section(data, title, values):
    if not values:
        return
    data.append("%%%s%%" % title)
    if isinstance(values, (list, tuple)):
        data.extend(str(item) for item in values)
    else:
        # just a single value
        data.append(str(values))
    data.append('\n')


class pmdb(object):
    """Database object
    """

    def __init__(self, treename, root):
        self.treename = treename
        self.root = root
        self.pkgs = []
        self.option = {}
        self.syncdir = True
        if self.treename == "local":
            self.dbdir = os.path.join(root, util.PM_DBPATH, treename)
            self.dbfile = None
            self.is_local = True
            self.read_dircache = None
            self.read_pkgcache = {}
        else:
            self.dbdir = None
            self.dbfile = os.path.join(root, util.PM_SYNCDBPATH, treename + ".db")
            self.is_local = False

    def __str__(self):
        return "%s" % self.treename

    def getverify(self):
        for value in ("Required", "Never", "Optional"):
            if value in self.treename:
                return value
        return "Never"

    def getpkg(self, name):
        for pkg in self.pkgs:
            if name == pkg.name:
                return pkg

    def db_read(self, name):
        if not self.dbdir or not os.path.isdir(self.dbdir):
            return None

        dbentry = None
        if self.read_dircache is None:
            self.read_dircache = os.listdir(self.dbdir)
        for entry in self.read_dircache:
            if entry == "ALPM_DB_VERSION":
                continue
            [pkgname, pkgver, pkgrel] = entry.rsplit("-", 2)
            if pkgname == name:
                dbentry = entry
                break
        if dbentry is None:
            return None

        if pkgname in self.read_pkgcache:
            return self.read_pkgcache[pkgname]

        pkg = pmpkg.pmpkg(pkgname, pkgver + "-" + pkgrel)
        self.read_pkgcache[pkgname] = pkg

        path = os.path.join(self.dbdir, dbentry)
        # desc
        filename = os.path.join(path, "desc")
        if not os.path.isfile(filename):
            tap.bail("invalid db entry found (desc missing) for pkg " + pkgname)
            return None
        fd = open(filename, "r")
        while 1:
            line = fd.readline()
            if not line:
                break
            line = line.strip("\n")
            if line == "%DESC%":
                pkg.desc = fd.readline().strip("\n")
            elif line == "%GROUPS%":
                pkg.groups = _getsection(fd)
            elif line == "%URL%":
                pkg.url = fd.readline().strip("\n")
            elif line == "%LICENSE%":
                pkg.license = _getsection(fd)
            elif line == "%ARCH%":
                pkg.arch = fd.readline().strip("\n")
            elif line == "%BUILDDATE%":
                pkg.builddate = fd.readline().strip("\n")
            elif line == "%INSTALLDATE%":
                pkg.installdate = fd.readline().strip("\n")
            elif line == "%PACKAGER%":
                pkg.packager = fd.readline().strip("\n")
            elif line == "%REASON%":
                try:
                    pkg.reason = int(fd.readline().strip("\n"))
                except ValueError:
                    pkg.reason = -1
                    raise
            elif line == "%SIZE%" or line == "%CSIZE%":
                try:
                    pkg.size = int(fd.readline().strip("\n"))
                except ValueError:
                    pkg.size = -1
                    raise
            elif line == "%MD5SUM%":
                pkg.md5sum = fd.readline().strip("\n")
            elif line == "%PGPSIG%":
                pkg.pgpsig = fd.readline().strip("\n")
            elif line == "%REPLACES%":
                pkg.replaces = _getsection(fd)
            elif line == "%DEPENDS%":
                pkg.depends = _getsection(fd)
            elif line == "%OPTDEPENDS%":
                pkg.optdepends = _getsection(fd)
            elif line == "%CONFLICTS%":
                pkg.conflicts = _getsection(fd)
            elif line == "%PROVIDES%":
                pkg.provides = _getsection(fd)
        fd.close()

        # files
        filename = os.path.join(path, "files")
        if not os.path.isfile(filename):
            tap.bail("invalid db entry found (files missing) for pkg " + pkgname)
            return None
        fd = open(filename, "r")
        while 1:
            line = fd.readline()
            if not line:
                break
            line = line.strip("\n")
            if line == "%FILES%":
                while line:
                    line = fd.readline().strip("\n")
                    if line:
                        pkg.files.append(line)
            if line == "%BACKUP%":
                pkg.backup = _getsection(fd)
        fd.close()

        # install
        filename = os.path.join(path, "install")

        return pkg

    #
    # db_write is used to add both 'local' and 'sync' db entries
    #
    def db_write(self, pkg):
        entry = {}
        # desc/depends type entries
        data = []
        make_section(data, "NAME", pkg.name)
        make_section(data, "VERSION", pkg.version)
        make_section(data, "DESC", pkg.desc)
        make_section(data, "GROUPS", pkg.groups)
        make_section(data, "LICENSE", pkg.license)
        make_section(data, "ARCH", pkg.arch)
        make_section(data, "BUILDDATE", pkg.builddate)
        make_section(data, "PACKAGER", pkg.packager)
        make_section(data, "DEPENDS", pkg.depends)
        make_section(data, "OPTDEPENDS", pkg.optdepends)
        make_section(data, "CONFLICTS", pkg.conflicts)
        make_section(data, "PROVIDES", pkg.provides)
        make_section(data, "URL", pkg.url)
        if self.is_local:
            make_section(data, "INSTALLDATE", pkg.installdate)
            make_section(data, "SIZE", pkg.size)
            make_section(data, "REASON", pkg.reason)
        else:
            make_section(data, "FILENAME", pkg.filename())
            make_section(data, "REPLACES", pkg.replaces)
            make_section(data, "CSIZE", pkg.csize)
            make_section(data, "ISIZE", pkg.isize)
            make_section(data, "MD5SUM", pkg.md5sum)
            make_section(data, "PGPSIG", pkg.pgpsig)

        entry["desc"] = "\n".join(data)

        # files and install
        if self.is_local:
            data = []
            make_section(data, "FILES", pkg.filelist())
            make_section(data, "BACKUP", pkg.local_backup_entries())
            entry["files"] = "\n".join(data)

            if any(pkg.install.values()):
                entry["install"] = pkg.installfile()

        return entry

    def generate(self):
        pkg_entries = [(pkg, self.db_write(pkg)) for pkg in self.pkgs]

        if self.dbdir:
            for pkg, entry in pkg_entries:
                path = os.path.join(self.dbdir, pkg.fullname())
                util.mkdir(path)
                for name, data in entry.items():
                    util.mkfile(path, name, data)

        if self.dbfile:
            tar = tarfile.open(self.dbfile, "w:gz")
            for pkg, entry in pkg_entries:
                # TODO: the addition of the directory is currently a
                # requirement for successful reading of a DB by libalpm
                info = tarfile.TarInfo(pkg.fullname())
                info.type = tarfile.DIRTYPE
                tar.addfile(info)
                for name, data in entry.items():
                    filename = os.path.join(pkg.fullname(), name)
                    info = tarfile.TarInfo(filename)
                    info.size = len(data)
                    tar.addfile(info, BytesIO(data.encode('utf8')))
            tar.close()
            # TODO: this is a bit unnecessary considering only one test uses it
            serverpath = os.path.join(self.root, util.SYNCREPO, self.treename)
            util.mkdir(serverpath)
            shutil.copy(self.dbfile, serverpath)
