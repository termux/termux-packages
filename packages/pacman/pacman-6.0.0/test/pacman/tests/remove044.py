self.description = "-Rs test"

lp1 = pmpkg("pkg1")
lp1.depends = ["pkg2=1.1-1"]
self.addpkg2db("local", lp1)

lp2 = pmpkg("pkg2", "1.0-1")
lp2.reason = 1
self.addpkg2db("local", lp2)


self.args = "-Rs %s" % lp1.name

self.addrule("PACMAN_RETCODE=0")
self.addrule("!PKG_EXIST=pkg1")
self.addrule("PKG_EXIST=pkg2")
