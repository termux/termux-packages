self.description = "upgrade introduces new directory that conflicts with a package file"

lp1 = pmpkg("pkg1")
lp1.files = ["usr/bin/foo"]
self.addpkg2db("local", lp1)

lp2 = pmpkg("pkg2")
self.addpkg2db("local", lp2)

p = pmpkg("pkg2", "1.0-2")
p.files = ["usr/bin/foo/"]
self.addpkg2db("sync", p)

self.args = "-S pkg2"

self.addrule("PACMAN_RETCODE=1")
self.addrule("PKG_VERSION=pkg2|1.0-1")
self.addrule("!DIR_EXIST=usr/bin/foo/")
