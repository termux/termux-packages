self.description = "Install a group from a sync db using --needed"

lp1 = pmpkg("pkg1")
lp2 = pmpkg("pkg2")
lp3 = pmpkg("pkg3")

sp1 = pmpkg("pkg1", "1.1-1")
sp2 = pmpkg("pkg2")
sp3 = pmpkg("pkg3")

for p in lp1, lp2, lp3, sp1, sp2, sp3:
	setattr(p, "groups", ["grp"])

for p in lp1, lp2, lp3:
	self.addpkg2db("local", p)

for p in sp1, sp2, sp3:
	self.addpkg2db("sync", p);

self.args = "-S --needed grp"

self.addrule("PACMAN_RETCODE=0")
for p in sp1, sp2, sp3:
	self.addrule("PKG_EXIST=%s" % p.name)
self.addrule("PKG_VERSION=pkg1|1.1-1")
