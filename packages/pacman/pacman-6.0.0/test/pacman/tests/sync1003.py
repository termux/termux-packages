self.description = "Induced removal would break dependency"

sp1 = pmpkg("pkg1", "1.0-2")
sp1.replaces = [ "pkg2" ]
self.addpkg2db("sync", sp1)

lp2 = pmpkg("pkg2", "1.0-1")
self.addpkg2db("local", lp2)

lp3 = pmpkg("pkg3", "1.0-1")
lp3.depends = [ "pkg2=1.0" ]
self.addpkg2db("local", lp3)

self.args = "-Su"

self.addrule("PACMAN_RETCODE=1")
self.addrule("!PKG_EXIST=pkg1")
self.addrule("PKG_EXIST=pkg2")
self.addrule("PKG_EXIST=pkg3")
self.addrule("PKG_VERSION=pkg2|1.0-1")
self.addrule("PKG_VERSION=pkg3|1.0-1")
