self.description = "System upgrade - conflict/provide with an installed package"

sp1 = pmpkg("pkg1", "1.0-2")
sp1.conflicts = ["pkg2"]
sp1.provides = ["pkg2"]
self.addpkg2db("sync", sp1);

lp1 = pmpkg("pkg1")
self.addpkg2db("local", lp1)

lp2 = pmpkg("pkg2")
self.addpkg2db("local", lp2)

self.args = "-Su --ask=4"

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_EXIST=pkg1")
self.addrule("!PKG_EXIST=pkg2")
