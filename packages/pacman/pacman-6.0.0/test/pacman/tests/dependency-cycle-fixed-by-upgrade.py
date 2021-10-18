self.description = "Circular dependency fixed by removed dependency"

lp1 = pmpkg("pkg1", "1-1")
lp1.depends = ["pkg2"]

lp2 = pmpkg("pkg2", "1-1")
lp2.depends = ["pkg3"]

lp3 = pmpkg("pkg3", "1-1")
lp3.depends = ["pkg1"]

for p in lp1, lp2, lp3:
	self.addpkg2db("local", p);

sp1 = pmpkg("pkg1", "1-2")
sp1.depends = ["pkg2"]

sp2 = pmpkg("pkg2", "1-2")

sp3 = pmpkg("pkg3", "1-2")
sp3.depends = ["pkg1"]

for p in sp1, sp2, sp3:
	self.addpkg2db("sync", p);

self.args = "-S %s %s %s" % (sp1.name, sp2.name, sp3.name)

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_VERSION=pkg1|1-2")
self.addrule("PKG_VERSION=pkg2|1-2")
self.addrule("PKG_VERSION=pkg3|1-2")
self.addrule("!PACMAN_OUTPUT=dependency cycle detected")
