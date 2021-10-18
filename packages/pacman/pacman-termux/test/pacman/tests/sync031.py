self.description = "Sync packages explicitly"

lp1 = pmpkg("pkg1")
lp1.reason = 1
self.addpkg2db("local", lp1)

p1 = pmpkg("pkg1", "1.0-2")
p2 = pmpkg("pkg2", "1.0-2")

for p in p1, p2:
	self.addpkg2db("sync", p)

self.args = "-S --asexplicit %s" % " ".join([p.name for p in (p1, p2)])

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_VERSION=pkg1|1.0-2")
self.addrule("PKG_VERSION=pkg2|1.0-2")
self.addrule("PKG_REASON=pkg1|0")
self.addrule("PKG_REASON=pkg2|0")
