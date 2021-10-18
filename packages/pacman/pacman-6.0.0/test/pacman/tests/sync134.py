self.description = "Sysupgrade with a set of sync packages replacing a local one"

sp1 = pmpkg("pkg2")
sp1.replaces = ["pkg1"]

sp2 = pmpkg("pkg3")
sp2.replaces = ["pkg1"]

for p in sp1, sp2:
	self.addpkg2db("sync", p)

lp = pmpkg("pkg1")

self.addpkg2db("local", lp)

self.args = "-Su"

self.addrule("PACMAN_RETCODE=0")
self.addrule("!PKG_EXIST=pkg1")
for p in sp1, sp2:
	self.addrule("PKG_EXIST=%s" % p.name)
