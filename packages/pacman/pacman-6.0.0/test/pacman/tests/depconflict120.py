self.description = "target vs db conflict will disappear after upgrade"

sp1 = pmpkg("pkg1")
sp1.conflicts = ["imaginary"]
self.addpkg2db("sync", sp1);

sp2 = pmpkg("pkg2", "1.0-2")
self.addpkg2db("sync", sp2)

lp = pmpkg("pkg2", "1.0-1")
lp.provides = ["imaginary"]
self.addpkg2db("local", lp)

self.args = "-S %s" % " ".join([p.name for p in (sp1, sp2)])

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_EXIST=pkg1")
self.addrule("PKG_EXIST=pkg2")
self.addrule("PKG_VERSION=pkg2|1.0-2")
