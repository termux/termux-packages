self.description = "Make sure ldconfig runs on an upgrade operation"

lp = pmpkg("dummy")
self.addpkg2db("local", lp)

p = pmpkg("dummy", "1.0-2")
self.addpkg(p)

self.args = "-U %s" % p.filename()

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_VERSION=dummy|1.0-2")
self.addrule("FILE_EXIST=etc/ld.so.cache")
