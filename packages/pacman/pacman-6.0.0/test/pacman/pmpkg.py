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
import tarfile

import util

class pmpkg(object):
    """Package object.

    Object holding data from an Arch Linux package.
    """

    def __init__(self, name, version = "1.0-1"):
        self.path = "" #the path of the generated package
        # desc
        self.name = name
        self.version = version
        self.desc = ""
        self.groups = []
        self.url = ""
        self.license = []
        self.arch = ""
        self.builddate = ""
        self.installdate = ""
        self.packager = ""
        self.size = 0
        self.csize = 0
        self.isize = 0
        self.reason = 0
        self.md5sum = ""      # sync only
        self.pgpsig = ""      # sync only
        self.replaces = []
        self.depends = []
        self.optdepends = []
        self.conflicts = []
        self.provides = []
        # files
        self.files = []
        self.backup = []
        # install
        self.install = {
            "pre_install": "",
            "post_install": "",
            "pre_remove": "",
            "post_remove": "",
            "pre_upgrade": "",
            "post_upgrade": "",
        }
        self.path = None
        self.finalized = False

    def __str__(self):
        s = ["%s" % self.fullname()]
        s.append("description: %s" % self.desc)
        s.append("url: %s" % self.url)
        s.append("files: %s" % " ".join(self.files))
        s.append("reason: %d" % self.reason)
        return "\n".join(s)

    def fullname(self):
        """Long name of a package.

        Returns a string formatted as follows: "pkgname-pkgver".
        """
        return "%s-%s" % (self.name, self.version)

    def filename(self):
        """File name of a package, including its extension.

        Returns a string formatted as follows: "pkgname-pkgver.PKG_EXT_PKG".
        """
        return "%s%s" % (self.fullname(), util.PM_EXT_PKG)

    @staticmethod
    def parse_filename(name):
        filename = name
        if filename[-1] == "*":
            filename = filename.rstrip("*")
        if filename.find(" -> ") != -1:
            filename, extra = filename.split(" -> ")
        elif filename.find("|") != -1:
            filename, extra = filename.split("|")
        return filename

    def makepkg_bytes(self):
        buf = BytesIO();
        self.makepkg(fileobj=buf)
        return buf.getvalue()

    def makepkg(self, path=None, fileobj=None):
        """Creates an Arch Linux package archive.

        A package archive is generated in the location 'path', based on the data
        from the object.
        """
        archive_files = []

        # .PKGINFO
        data = ["pkgname = %s" % self.name]
        data.append("pkgver = %s" % self.version)
        data.append("pkgdesc = %s" % self.desc)
        data.append("url = %s" % self.url)
        data.append("builddate = %s" % self.builddate)
        data.append("packager = %s" % self.packager)
        data.append("size = %s" % self.size)
        if self.arch:
            data.append("arch = %s" % self.arch)
        for i in self.license:
            data.append("license = %s" % i)
        for i in self.replaces:
            data.append("replaces = %s" % i)
        for i in self.groups:
            data.append("group = %s" % i)
        for i in self.depends:
            data.append("depend = %s" % i)
        for i in self.optdepends:
            data.append("optdepend = %s" % i)
        for i in self.conflicts:
            data.append("conflict = %s" % i)
        for i in self.provides:
            data.append("provides = %s" % i)
        for i in self.backup:
            data.append("backup = %s" % i)
        archive_files.append((".PKGINFO", "\n".join(data)))

        # .INSTALL
        if any(self.install.values()):
            archive_files.append((".INSTALL", self.installfile()))

        if path:
            self.path = os.path.join(path, self.filename())
            util.mkdir(os.path.dirname(self.path))

        # Generate package metadata
        tar = tarfile.open(name=self.path, fileobj=fileobj, mode="w:gz", format=tarfile.GNU_FORMAT)
        for name, data in archive_files:
            info = tarfile.TarInfo(name)
            info.size = len(data)
            tar.addfile(info, BytesIO(data.encode('utf8')))

        # Generate package file system
        for name in self.files:
            fileinfo = util.getfileinfo(name)
            info = tarfile.TarInfo(fileinfo["filename"])
            if fileinfo["hasperms"]:
                info.mode = fileinfo["perms"]
            elif fileinfo["isdir"]:
                info.mode = 0o755
            if fileinfo["isdir"]:
                info.type = tarfile.DIRTYPE
                tar.addfile(info)
            elif fileinfo["islink"]:
                info.type = tarfile.SYMTYPE
                info.linkname = fileinfo["link"]
                tar.addfile(info)
            else:
                # TODO wow what a hack, adding a newline to match mkfile?
                filedata = name + "\n"
                info.size = len(filedata)
                tar.addfile(info, BytesIO(filedata.encode('utf8')))

        tar.close()

    def install_package(self, root):
        """Install the package in the given root."""
        for f in self.files:
            path = util.mkfile(root, f, f)
            if os.path.isfile(path):
                os.utime(path, (355, 355))

    def filelist(self):
        """Generate a list of package files."""
        return sorted([self.parse_filename(f) for f in self.files])

    def finalize(self):
        """Perform any necessary operations to ready the package for use."""
        if self.finalized:
            return

        # add missing parent dirs to file list
        # use bare file names so trailing ' -> ', '*', etc don't throw off the
        # checks for existing files
        file_names = self.filelist()
        for name in list(file_names):
            if os.path.isabs(name):
                raise ValueError("Absolute path in filelist '%s'." % name)

            name = os.path.dirname(name.rstrip("/"))
            while name:
                if name in file_names:
                    # path exists as both a file and a directory
                    raise ValueError("Duplicate path in filelist '%s'." % name)
                elif name + "/" in file_names:
                    # path was either manually included or already processed
                    break
                else:
                    file_names.append(name + "/")
                    self.files.append(name + "/")
                name = os.path.dirname(name)
        self.files.sort()

        self.finalized = True

    def local_backup_entries(self):
        return ["%s\t%s" % (self.parse_filename(i), util.mkmd5sum(i)) for i in self.backup]

    def installfile(self):
        data = []
        for key, value in self.install.items():
            if value:
                data.append("%s() {\n%s\n}\n" % (key, value))

        return "\n".join(data)
