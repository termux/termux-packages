self.description = "Sync causes single package removal of a provide (success)"

sp = pmpkg("pkg3")
sp.conflicts = ["pkg1"]
sp.provides = ["foo"]
self.addpkg2db("sync", sp)

lp1 = pmpkg("pkg1")
lp1.provides = ["foo"]
self.addpkg2db("local", lp1)

lp2 = pmpkg("pkg2")
lp2.depends = ["foo"]
self.addpkg2db("local", lp2)

self.args = "-S %s --ask=4" % sp.name

self.addrule("PACMAN_RETCODE=0")
self.addrule("!PKG_EXIST=pkg1")
self.addrule("PKG_EXIST=pkg2")
self.addrule("PKG_EXIST=pkg3")
