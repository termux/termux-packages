self.description = "Upgrade to a package that provides another package"

lp = pmpkg("pkg1")
self.addpkg2db("local", lp)

p = pmpkg("pkg2")
p.conflicts = ["pkg1"]
p.provides = ["pkg1"]
self.addpkg(p)

self.args = "-U %s --ask=4" % p.filename()

self.addrule("PACMAN_RETCODE=0")
self.addrule("!PKG_EXIST=pkg1")
self.addrule("PKG_EXIST=pkg2")
