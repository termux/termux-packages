self.description = "Sysupgrade of packages in fnmatch'd IgnoreGroup"

sp1 = pmpkg("pkg1", "1.0-2")
sp1.groups = ["grp"]
sp2 = pmpkg("pkg2", "1.0-2")
sp2.groups = ["grp2"]

for p in sp1, sp2:
	self.addpkg2db("sync", p)

lp1 = pmpkg("pkg1", "1.0-1")
lp2 = pmpkg("pkg2", "1.0-1")

for p in lp1, lp2:
	self.addpkg2db("local", p)

self.option["IgnoreGroup"] = ["grp"]

self.args = "-Su"

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_VERSION=pkg1|1.0-1")
self.addrule("PKG_VERSION=pkg2|1.0-2")
