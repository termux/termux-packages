self.description = "Sysupgrade of a package pulling new dependencies"

sp1 = pmpkg("pkg1", "1.0-2")
sp1.depends = ["pkg2"]

sp2 = pmpkg("pkg2")
sp2.depends = ["pkg3"]

sp3 = pmpkg("pkg3")

for p in sp1, sp2, sp3:
	self.addpkg2db("sync", p)

lp1 = pmpkg("pkg1")
self.addpkg2db("local", lp1)

self.args = "-Su"

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_VERSION=pkg1|1.0-2")
for p in sp2, sp3:
	self.addrule("PKG_REASON=%s|1" % p.name)
