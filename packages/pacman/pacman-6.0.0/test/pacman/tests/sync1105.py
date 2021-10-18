self.description = "Upgrade with a replacement in a repo with lower prioriy"

sp1 = pmpkg("pkg2")
self.addpkg2db("sync1", sp1)

sp2 = pmpkg("pkg1")
sp2.replaces = ["pkg2"]
self.addpkg2db("sync2", sp2)

lp = pmpkg("pkg2")
self.addpkg2db("local", lp)

self.args = "-Su"

self.addrule("PACMAN_RETCODE=0")
self.addrule("!PKG_EXIST=pkg1")
self.addrule("PKG_EXIST=pkg2")
