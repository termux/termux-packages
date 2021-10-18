self.description = "-Rs test (dependency chain)"

lp1 = pmpkg("pkg1")
lp1.depends = ["pkg2"]
self.addpkg2db("local", lp1)

lp2 = pmpkg("pkg2")
lp2.depends = ["pkg3"]
lp2.reason = 1
self.addpkg2db("local", lp2)

lp3 = pmpkg("pkg3")
lp3.reason = 1
self.addpkg2db("local", lp3)

self.args = "-Rs %s" % " ".join([p.name for p in (lp1, lp3)])

self.addrule("PACMAN_RETCODE=0")
self.addrule("!PKG_EXIST=pkg1")
self.addrule("!PKG_EXIST=pkg2")
self.addrule("!PKG_EXIST=pkg3")
