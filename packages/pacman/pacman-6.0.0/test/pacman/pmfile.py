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
import stat

import util

class pmfile(object):
    def __init__(self, path, content, mode=0o644):
        self.path = path
        self.content = content
        self.mode = mode

    def mkfile(self, root):
        path = os.path.join(root, self.path)

        dir_path = os.path.dirname(path)
        if dir_path and not os.path.isdir(dir_path):
            os.makedirs(dir_path, 0o755)

        fd = open(path, "w")
        if self.content:
            fd.write(self.content)
            if self.content[-1] != "\n":
                fd.write("\n")
        fd.close()

        os.chmod(path, self.mode)

        return path


class snapshot(object):
    """File object
    """

    def __init__(self, root, name):
        self.root = root
        self.name = name
        self.filename = os.path.join(self.root, self.name)

        self.checksum = util.getmd5sum(self.filename)
        self.mtime = self.getmtime()

    def __str__(self):
        return "%s (%s / %lu)" % (self.name, self.checksum, self.mtime)

    def getmtime(self):
        if not os.path.exists(self.filename):
            return None, None
        statbuf = os.lstat(self.filename)
        return (statbuf[stat.ST_MTIME], statbuf[stat.ST_CTIME])

    def ismodified(self):
        checksum = util.getmd5sum(self.filename)
        mtime = self.getmtime()

        util.vprint("\tismodified(%s)" % self.name)
        util.vprint("\t\told: %s / %s" % (self.checksum, self.mtime))
        util.vprint("\t\tnew: %s / %s" % (checksum, mtime))

        if self.checksum != checksum \
                or self.mtime[0] != mtime[0] \
                or self.mtime[1] != mtime[1]:
            return True

        return False
