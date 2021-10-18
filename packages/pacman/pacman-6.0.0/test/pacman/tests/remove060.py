self.description = "Remove a group"

lp1 = pmpkg("pkg1")
lp1.groups = ["grp"]

lp2 = pmpkg("pkg2")

lp3 = pmpkg("pkg3")
lp3.groups = ["grp"]

for p in lp1, lp2, lp3:
	self.addpkg2db("local", p);

self.args = "-R grp"

self.addrule("PACMAN_RETCODE=0")
self.addrule("!PKG_EXIST=pkg1")
self.addrule("PKG_EXIST=pkg2")
self.addrule("!PKG_EXIST=pkg3")
