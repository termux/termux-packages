self.description = "Upgrade a package that loses a provides entry which moves to a dedicated package"

lp1 = pmpkg("pkg1", "1-1")
lp1.provides = ["feature=1"]
lp2 = pmpkg("pkg2")
lp2.depends = ["feature"]

for p in lp1, lp2:
	self.addpkg2db("local", p)

sp1 = pmpkg("pkg1", "2-1")
# NOTE: no provides for feature anymore
sp2 = pmpkg("feature", "2-1")

for p in sp1, sp2:
	self.addpkg2db("sync", p)

self.args = "-Su"

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_VERSION=feature|2-1")
self.addrule("PKG_VERSION=pkg1|2-1")
self.expectfailure = True
