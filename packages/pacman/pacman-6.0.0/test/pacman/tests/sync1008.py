self.description = "Conflicting package names in sync repos"

sp1 = pmpkg("cpkg", "1.0-1")
sp1.provides = [ "provision1" ]
self.addpkg2db("sync1", sp1)

sp2 = pmpkg("cpkg", "2.0-1")
sp2.provides = [ "provision2" ]
self.addpkg2db("sync2", sp2)

sp3 = pmpkg("pkg")
sp3.depends = [ "provision1" , "provision2" ]
self.addpkg2db("sync1", sp3)

self.args = "-S pkg"

self.addrule("PACMAN_RETCODE=1")
self.addrule("!PKG_EXIST=pkg")
self.addrule("!PKG_EXIST=cpkg")
