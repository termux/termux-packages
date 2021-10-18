self.description = "Install two conflicting targets"

sp1 = pmpkg("pkg1")
sp1.conflicts = ["pkg2"]

sp2 = pmpkg("pkg2")
sp2.conflicts = ["pkg1"]

for p in sp1, sp2:
	self.addpkg2db("sync", p);

self.args = "-S %s" % " ".join([p.name for p in (sp1, sp2)])

self.addrule("PACMAN_RETCODE=1")
self.addrule("!PKG_EXIST=pkg1")
self.addrule("!PKG_EXIST=pkg2")
