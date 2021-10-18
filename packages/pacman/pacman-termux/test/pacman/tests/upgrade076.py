self.description = "Package downgrade (failure)"

lp1 = pmpkg("pkg1")
lp1.depends = ["pkg2=1.1"]
self.addpkg2db("local", lp1)

lp2 = pmpkg("pkg2", "1.1-1")
self.addpkg2db("local", lp2)

p = pmpkg("pkg2", "1.0-1")
self.addpkg(p)

self.args = "-U %s" % p.filename()

self.addrule("PACMAN_RETCODE=1")
self.addrule("PKG_EXIST=pkg1")
self.addrule("PKG_EXIST=pkg2")
self.addrule("PKG_VERSION=pkg2|1.1-1")
