self.description = "Try to upgrade two packages which would break deps"

lp1 = pmpkg("pkg1")
lp1.depends = ["pkg2=1.0"]
self.addpkg2db("local", lp1)

lp2 = pmpkg("pkg2", "1.0-1")
self.addpkg2db("local", lp2)

p1 = pmpkg("pkg1", "1.1-1")
p1.depends = ["pkg2=1.0-1"]
self.addpkg(p1)

p2 = pmpkg("pkg2", "1.1-1")
self.addpkg(p2)

self.args = "-U %s" % " ".join([p.filename() for p in (p1, p2)])

self.addrule("PACMAN_RETCODE=1")
self.addrule("PKG_VERSION=pkg1|1.0-1")
self.addrule("PKG_VERSION=pkg2|1.0-1")
