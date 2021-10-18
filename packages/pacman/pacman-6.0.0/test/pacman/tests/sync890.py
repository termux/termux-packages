self.description = "conflict 'db vs targ'"

sp = pmpkg("pkg3")

self.addpkg2db("sync", sp)

lp1 = pmpkg("pkg1")

lp2 = pmpkg("pkg2")
lp2.conflicts = ["pkg3"]

for p in lp1, lp2:
	self.addpkg2db("local", p)

self.args = "-S %s --ask=4" % sp.name

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_EXIST=pkg1")
self.addrule("!PKG_EXIST=pkg2")
self.addrule("PKG_EXIST=pkg3")
