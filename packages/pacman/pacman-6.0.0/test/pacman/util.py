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
import re
import hashlib

import tap

SELFPATH    = os.path.abspath(os.path.dirname(__file__))

# ALPM
PM_ROOT     = "/"
PM_DBPATH   = "var/lib/pacman"
PM_SYNCDBPATH = "var/lib/pacman/sync"
PM_LOCK     = "var/lib/pacman/db.lck"
PM_CACHEDIR = "var/cache/pacman/pkg"
PM_EXT_PKG  = ".pkg.tar.gz"
PM_HOOKDIR  = "etc/pacman.d/hooks"

# Pacman
PACCONF     = "etc/pacman.conf"

# Pactest
TMPDIR      = "tmp"
SYNCREPO    = "var/pub"
LOGFILE     = "var/log/pactest.log"

verbose = 0

def vprint(msg):
    if verbose:
        tap.diag(msg)

#
# Methods to generate files
#

def getfileinfo(filename):
    data = {
        'changed': False,
        'isdir': False,
        'islink': False,
        'link': None,
        'hasperms': False,
        'perms': None,
    }
    if filename[-1] == "*":
        data["changed"] = True
        filename = filename.rstrip("*")
    if filename.find(" -> ") != -1:
        filename, link = filename.split(" -> ")
        data["islink"] = True
        data["link"] = link
    elif filename.find("|") != -1:
        filename, perms = filename.split("|")
        data["hasperms"] = True
        data["perms"] = int(perms, 8)
    if filename[-1] == "/":
        data["isdir"] = True

    data["filename"] = filename
    return data

def mkfile(base, name, data=""):
    info = getfileinfo(name)
    filename = info["filename"]

    path = os.path.join(base, filename)
    if info["isdir"]:
        if not os.path.isdir(path):
            os.makedirs(path, 0o755)
        return path

    dir_path = os.path.dirname(path)
    if dir_path and not os.path.isdir(dir_path):
        os.makedirs(dir_path, 0o755)

    if info["islink"]:
        os.symlink(info["link"], path)
    else:
        writedata(path, data)

    if info["perms"]:
        os.chmod(path, info["perms"])

    return path

def writedata(filename, data):
    if isinstance(data, list):
        data = "\n".join(data)
    fd = open(filename, "w")
    if data:
        fd.write(data)
        if data[-1] != "\n":
            fd.write("\n")
    fd.close()

def mkcfgfile(filename, root, option, db):
    # Options
    data = ["[options]"]
    for key, value in option.items():
        data.extend(["%s = %s" % (key, j) for j in value])

    # Repositories
    # sort by repo name so tests can predict repo order, rather than be
    # subjects to the whims of python dict() ordering
    for key in sorted(db.keys()):
        if key != "local":
            value = db[key]
            data.append("[%s]\n" % (value.treename))
            data.append("SigLevel = %s\n" % (value.getverify()))
            if value.syncdir:
                data.append("Server = file://%s" % (os.path.join(root, SYNCREPO, value.treename)))
            for optkey, optval in value.option.items():
                data.extend(["%s = %s" % (optkey, j) for j in optval])

    mkfile(root, filename, "\n".join(data))


#
# MD5 helpers
#

def getmd5sum(filename):
    if not os.path.isfile(filename):
        return ""
    fd = open(filename, "rb")
    checksum = hashlib.md5()
    while 1:
        block = fd.read(32 * 1024)
        if not block:
            break
        checksum.update(block)
    fd.close()
    return checksum.hexdigest()

def mkmd5sum(data):
    checksum = hashlib.md5()
    checksum.update(("%s\n" % data).encode('utf8'))
    return checksum.hexdigest()


#
# Miscellaneous
#

def which(filename, path=None):
    if not path:
        path = os.environ["PATH"].split(os.pathsep)
    for p in path:
        f = os.path.join(p, filename)
        if os.access(f, os.F_OK):
            return f
    return None

def grep(filename, pattern):
    pat = re.compile(pattern)
    myfile = open(filename, 'r')
    for line in myfile:
        if pat.search(line):
            myfile.close()
            return True
    myfile.close()
    return False

def mkdir(path):
    if os.path.isdir(path):
        return
    elif os.path.isfile(path):
        raise OSError("'%s' already exists and is not a directory" % path)
    os.makedirs(path, 0o755)
