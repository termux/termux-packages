self.description = "conflict 'db vs db'"

sp1 = pmpkg("pkg1", "1.0-2")
sp1.conflicts = ["pkg2"]
self.addpkg2db("sync", sp1);

sp2 = pmpkg("pkg2", "1.0-2")
self.addpkg2db("sync", sp2)

lp1 = pmpkg("pkg1")
self.addpkg2db("local", lp1)

lp2 = pmpkg("pkg2")
self.addpkg2db("local", lp2)

self.args = "-S %s --ask=4" % " ".join([p.name for p in (sp1, sp2)])

self.addrule("PACMAN_RETCODE=1")
self.addrule("PKG_EXIST=pkg1")
self.addrule("PKG_EXIST=pkg2")
