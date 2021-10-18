self.description = "provision>=1.0-2 dependency"

p = pmpkg("pkg1", "1.0-2")
p.depends = ["provision>=1.0-2"]
self.addpkg2db("sync", p)

lp = pmpkg("pkg2", "1.0-2")
lp.provides = ["provision"]
self.addpkg2db("local", lp)

self.args = "-S %s" % p.name

self.addrule("PACMAN_RETCODE=1")
self.addrule("!PKG_EXIST=pkg1")
self.addrule("PKG_EXIST=pkg2")
