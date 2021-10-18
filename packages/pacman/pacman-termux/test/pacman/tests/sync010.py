self.description = "Install a package from a sync db with cascaded dependencies"

sp1 = pmpkg("dummy", "1.0-2")
sp1.files = ["bin/dummy",
             "usr/man/man1/dummy.1"]
sp1.depends = ["dep1"]

sp2 = pmpkg("dep1")
sp2.files = ["bin/dep1"]
sp2.depends = ["dep2"]

sp3 = pmpkg("dep2")
sp3.files = ["bin/dep2"]

for p in sp1, sp2, sp3:
	self.addpkg2db("sync", p);

self.args = "-S %s" % sp1.name

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_VERSION=dummy|1.0-2")
self.addrule("PKG_DEPENDS=dummy|dep1")
for p in sp1, sp2, sp3:
	self.addrule("PKG_EXIST=%s" % p.name)
	for f in p.files:
		self.addrule("FILE_EXIST=%s" % f)
self.addrule("PKG_DEPENDS=dep1|dep2")
