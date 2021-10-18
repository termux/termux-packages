self.description = "Remove a package required by other packages"

lp1 = pmpkg("pkg1")
self.addpkg2db("local", lp1)

lp2 = pmpkg("pkg2")
lp2.depends = ["pkg1"]
self.addpkg2db("local", lp2)

lp3 = pmpkg("pkg3")
lp3.depends = ["pkg1"]
self.addpkg2db("local", lp3)

lp4 = pmpkg("pkg4")
lp4.depends = ["pkg1"]
self.addpkg2db("local", lp4)

self.args = "-R pkg1 pkg2"

self.addrule("!PACMAN_RETCODE=0")
self.addrule("PKG_EXIST=pkg1")
self.addrule("PKG_EXIST=pkg2")
self.addrule("PKG_EXIST=pkg3")
self.addrule("PKG_EXIST=pkg4")
