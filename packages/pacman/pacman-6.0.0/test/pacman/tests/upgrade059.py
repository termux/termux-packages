self.description = "Upgrade packages which would break a multiple-depend"

lp1 = pmpkg("pkg1")
lp1.depends = ["imaginary"]
self.addpkg2db("local", lp1)

lp2 = pmpkg("pkg2", "1.0-1")
lp2.provides = ["imaginary"]
self.addpkg2db("local", lp2)

lp3 = pmpkg("pkg3", "1.0-1")
lp3.provides = ["imaginary"]
self.addpkg2db("local", lp3)

p2 = pmpkg("pkg2", "1.0-2")
self.addpkg(p2)

p3 = pmpkg("pkg3", "1.0-2")
self.addpkg(p3)

self.args = "-U %s" % " ".join([p.filename() for p in (p2, p3)])

self.addrule("PACMAN_RETCODE=1")
self.addrule("PKG_EXIST=pkg1")
self.addrule("PKG_VERSION=pkg2|1.0-1")
self.addrule("PKG_VERSION=pkg3|1.0-1")
