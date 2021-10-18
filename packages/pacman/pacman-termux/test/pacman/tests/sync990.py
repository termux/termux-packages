self.description = "Sync a package pulling a dependency conflicting with a target"

sp1 = pmpkg("pkg1")
sp1.depends = ["pkg3"]

sp2 = pmpkg("pkg2")

sp3 = pmpkg("pkg3")
sp3.conflicts = ["pkg2"]

for p in sp1, sp2, sp3:
	self.addpkg2db("sync", p)

self.args = "-S %s" % " ".join([p.name for p in (sp1, sp2)])

self.addrule("PACMAN_RETCODE=1")
self.addrule("!PKG_EXIST=pkg1")
self.addrule("!PKG_EXIST=pkg2")
self.addrule("!PKG_EXIST=pkg3")
