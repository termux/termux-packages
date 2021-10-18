self.description = "nodepversion: -Sud works"

p1 = pmpkg("pkg1", "1.0-1")
p1.depends = ["provision=1.0"]
self.addpkg2db("local", p1)

p2 = pmpkg("pkg2", "1.0-1")
p2.provides = ["provision=1.0"]
self.addpkg2db("local", p2)

sp2 = pmpkg("pkg2", "1.1-1")
sp2.provides = ["provision=1.1"]
self.addpkg2db("sync", sp2)

self.args = "-Sud"

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_VERSION=pkg1|1.0-1")
self.addrule("PKG_VERSION=pkg2|1.1-1")
