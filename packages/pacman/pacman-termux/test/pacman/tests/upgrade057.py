self.description = "Upgrade a package that both provides and is a dependency"

lp1 = pmpkg("pkg1")
lp1.depends = ["pkg2", "imag3"]
self.addpkg2db("local", lp1)

lp2 = pmpkg("pkg2")
lp2.provides = ["imag3"]
self.addpkg2db("local", lp2)

p = pmpkg("pkg2", "1.0-2")
p.provides = ["imag3"]
self.addpkg(p)

self.args = "-U %s" % p.filename()

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_EXIST=pkg1")
self.addrule("PKG_VERSION=pkg2|1.0-2")
self.addrule("PKG_DEPENDS=pkg1|pkg2")
self.addrule("PKG_DEPENDS=pkg1|imag3")
