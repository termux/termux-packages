self.description = "Upgrade packages with various reasons"

lp1 = pmpkg("pkg1")
lp1.reason = 0
lp2 = pmpkg("pkg2")
lp2.reason = 1

for p in lp1, lp2:
	self.addpkg2db("local", p)

p1 = pmpkg("pkg1", "1.0-2")
p2 = pmpkg("pkg2", "1.0-2")

for p in p1, p2:
	self.addpkg(p)

self.args = "-U %s" % " ".join([p.filename() for p in (p1, p2)])

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_REASON=pkg1|0")
self.addrule("PKG_REASON=pkg2|1")
