self.description = "Sysupgrade of packages in 'IgnorePkg'"

sp1 = pmpkg("pkg1", "1.0-2")
sp2 = pmpkg("pkg2", "1.0-2")

for p in sp1, sp2:
	self.addpkg2db("sync", p)

lp1 = pmpkg("pkg1")
lp2 = pmpkg("pkg2")

for p in lp1, lp2:
	self.addpkg2db("local", p)

self.option["IgnorePkg"] = ["pkg2"]

self.args = "-Su"

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_VERSION=pkg1|1.0-2")
self.addrule("PKG_VERSION=pkg2|1.0-1")
