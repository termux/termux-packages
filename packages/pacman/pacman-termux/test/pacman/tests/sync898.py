self.description = "System upgrade with conflicts and provides"

sp1 = pmpkg("pkg1", "1.0-2")
sp1.conflicts = ["pkg2"]
sp1.provides = ["pkg2"]
self.addpkg2db("sync", sp1);

sp2 = pmpkg("pkg2", "1.0-2")
self.addpkg2db("sync", sp2)

lp1 = pmpkg("pkg1")
self.addpkg2db("local", lp1)

self.args = "-S %s" % " ".join([p.name for p in (sp1, sp2)])

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_VERSION=pkg1|1.0-2")
self.addrule("!PKG_EXIST=pkg2")
