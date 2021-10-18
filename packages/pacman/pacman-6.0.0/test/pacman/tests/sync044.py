self.description = "A dependency induces a replacement"

lp1 = pmpkg("pkg1")
self.addpkg2db("local", lp1);

sp2 = pmpkg("pkg2")
sp2.depends = ["pkg3"]
self.addpkg2db("sync", sp2);

sp3 = pmpkg("pkg3")
sp3.conflicts = ["pkg1"]
self.addpkg2db("sync", sp3);

self.args = "-S pkg2 --ask=4"

self.addrule("PACMAN_RETCODE=0")
self.addrule("!PKG_EXIST=pkg1")
self.addrule("PKG_EXIST=pkg2")
self.addrule("PKG_EXIST=pkg3")
self.addrule("PKG_REASON=pkg3|1")
