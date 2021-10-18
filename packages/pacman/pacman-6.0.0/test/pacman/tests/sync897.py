self.description = "System upgrade with package conflicts"

sp1 = pmpkg("pkg1", "1.0-2")
sp1.conflicts = ["pkg2", "pkg3"]
self.addpkg2db("sync", sp1);

sp2 = pmpkg("pkg2", "1.0-2")
self.addpkg2db("sync", sp2)

lp1 = pmpkg("pkg1")
self.addpkg2db("local", lp1)

lp2 = pmpkg("pkg2")
self.addpkg2db("local", lp2)

lp3 = pmpkg("pkg3")
self.addpkg2db("local", lp3)

self.args = "-Su --ask=4"

self.addrule("PACMAN_RETCODE=1")
self.addrule("PKG_EXIST=pkg1")
self.addrule("PKG_EXIST=pkg2")
self.addrule("PKG_EXIST=pkg3")
