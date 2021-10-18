self.description = "nodepversion: provision does not exist"

p1 = pmpkg("pkg1", "1.0-2")
p1.depends = ["invalid>=1.0-2"]
self.addpkg2db("sync", p1)

p2 = pmpkg("pkg2", "1.0-2")
p2.provides = ["provision=1.0-1"]
self.addpkg2db("sync", p2)

self.args = "-Sd %s" % p1.name

self.addrule("PACMAN_RETCODE=1")
self.addrule("!PKG_EXIST=pkg1")
self.addrule("!PKG_EXIST=pkg2")
