self.description = "Unowned broken symlink replaced by one in package"

lp = pmpkg("dummy")
lp.files = ["usr/bin/myprog"]
self.addpkg2db("local", lp)

self.filesystem = ["usr/bin/otherprog",
                   "usr/bin/myprogsuffix -> broken"]

p = pmpkg("dummy", "1.0-2")
p.files = ["usr/bin/myprog",
           "usr/bin/myprogsuffix -> myprog"]
self.addpkg(p)

self.args = "-U %s" % p.filename()

self.addrule("PACMAN_RETCODE=1")
self.addrule("PKG_VERSION=dummy|1.0-1")
self.addrule("FILE_EXIST=usr/bin/myprog")
self.addrule("LINK_EXIST=usr/bin/myprogsuffix")
self.addrule("FILE_EXIST=usr/bin/otherprog")
self.addrule("FILE_TYPE=usr/bin/myprog|file")
self.addrule("FILE_TYPE=usr/bin/myprogsuffix|link")
self.addrule("FILE_TYPE=usr/bin/otherprog|file")
