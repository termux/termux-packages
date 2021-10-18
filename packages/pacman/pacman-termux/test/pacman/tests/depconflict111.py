self.description = "conflict with version (no conflict)"

p = pmpkg("pkg1")
p.conflicts = ["pkg2=1.0-2"]
self.addpkg(p);

lp = pmpkg("pkg2", "1.0-1")
self.addpkg2db("local", lp)

self.args = "-U %s" % p.filename()
self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_EXIST=pkg1")
self.addrule("PKG_EXIST=pkg2")
