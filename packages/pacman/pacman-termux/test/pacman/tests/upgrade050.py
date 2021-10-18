self.description = "Upgrade package with a conflict == depend (not installed)"

p1 = pmpkg("pkg1")
p1.conflicts = ["pkg2"]
p1.depends = ["pkg2"]
self.addpkg(p1)

p2 = pmpkg("pkg2")
self.addpkg(p2)

self.args = "-U %s" % " ".join([p.filename() for p in (p1, p2)])

self.addrule("PACMAN_RETCODE=1")
self.addrule("!PKG_EXIST=pkg1")
self.addrule("!PKG_EXIST=pkg2")
