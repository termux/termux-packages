self.description = "Upgrade a package with dependency on provided package (different)"

lp1 = pmpkg("pkg1")
lp1.depends = ["imaginary"]
self.addpkg2db("local", lp1)

lp2 = pmpkg("pkg2")
lp2.provides = ["imaginary", "real"]
self.addpkg2db("local", lp2)

p = pmpkg("pkg1", "1.0-2")
p.depends = ["real"]
self.addpkg(p)

self.args = "-U %s" % p.filename()

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_VERSION=pkg1|1.0-2")
self.addrule("PKG_EXIST=pkg2")
