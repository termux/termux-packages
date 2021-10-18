self.description = "-Rss test (include explicit)"

lp1 = pmpkg("pkg1")
lp1.depends = ["pkg2" , "pkg3"]
self.addpkg2db("local", lp1)

lp2 = pmpkg("pkg2")
lp2.reason = 1
self.addpkg2db("local", lp2)

lp3 = pmpkg("pkg3")
lp3.reason = 0
self.addpkg2db("local", lp3)

self.args = "-Rss %s" % lp1.name

self.addrule("PACMAN_RETCODE=0")
self.addrule("!PKG_EXIST=pkg1")
self.addrule("!PKG_EXIST=pkg2")
self.addrule("!PKG_EXIST=pkg3")
