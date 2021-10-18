self.description = "conflict 'db vs targ'"

sp1 = pmpkg("pkg2")
sp2 = pmpkg("pkg3")

for p in sp1, sp2:
	self.addpkg2db("sync", p)

lp1 = pmpkg("pkg1")

lp2 = pmpkg("pkg2")
lp2.conflicts = ["pkg3"]

for p in lp1, lp2:
	self.addpkg2db("local", p)

self.args = "-S %s" % " ".join([p.name for p in (sp1, sp2)])

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_EXIST=pkg1")
self.addrule("PKG_EXIST=pkg2")
self.addrule("PKG_EXIST=pkg3")
