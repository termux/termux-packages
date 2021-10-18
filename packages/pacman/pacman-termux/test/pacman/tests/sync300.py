self.description = "Sync with corrupt database (broken deps)"

sp1 = pmpkg("pkg1")
sp1.depends = ["pkg2=1.1"]
self.addpkg2db("sync", sp1)

sp2 = pmpkg("pkg2", "1.0-1")
self.addpkg2db("sync", sp2)

self.args = "-S %s" % sp1.name

self.addrule("PACMAN_RETCODE=1")
self.addrule("!PKG_EXIST=pkg1")
self.addrule("!PKG_EXIST=pkg2")
