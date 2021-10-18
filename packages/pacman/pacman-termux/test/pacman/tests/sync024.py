self.description = "Install a group from a sync db repo/group syntax"

sp1 = pmpkg("pkg1")
sp2 = pmpkg("pkg2")
sp3 = pmpkg("pkg3")
newp1 = pmpkg("pkg1", "1.2-1")

for p in sp1, sp2, sp3, newp1:
	setattr(p, "groups", ["grp"])

self.addpkg2db("testing", newp1);

for p in sp1, sp2, sp3:
	self.addpkg2db("sync", p);

self.args = "-S testing/grp"

self.addrule("PACMAN_RETCODE=0")
for p in sp2, sp3:
	self.addrule("!PKG_EXIST=%s" % p.name)
self.addrule("PKG_EXIST=%s" % newp1.name)
# The newer version should still be installed
self.addrule("PKG_VERSION=pkg1|1.2-1")
