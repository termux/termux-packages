self.description = "Install a package from a sync db with cascaded dependencies + provides"

sp1 = pmpkg("dummy", "1.0-2")
sp1.depends = ["dep1", "dep2=1.0-2"]

sp2 = pmpkg("dep1")
sp2.files = ["bin/dep1"]
sp2.provides = ["dep2"]

sp3 = pmpkg("dep2", "1.0-2")

for p in sp1, sp2, sp3:
	self.addpkg2db("sync", p);

self.args = "-S %s" % sp1.name

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_VERSION=dummy|1.0-2")
self.addrule("PKG_EXIST=dep1")
self.addrule("PKG_EXIST=dep2")
