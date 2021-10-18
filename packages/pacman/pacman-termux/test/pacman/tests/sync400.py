self.description = "Install package with dep that conflicts with older version of package"

sp1 = pmpkg("pkg1", "1.0-2")
sp1.depends = ["pkg2=1.0-2"]
self.addpkg2db("sync", sp1)

sp2 = pmpkg("pkg2", "1.0-2")
sp2.conflicts = [ "pkg1=1.0-1" ]
self.addpkg2db("sync", sp2)

lp1 = pmpkg("pkg1", "1.0-1")
lp1.depends = ["pkg2=1.0-1"]
self.addpkg2db("local", lp1)

lp2 = pmpkg("pkg2", "1.0-1")
self.addpkg2db("local", lp2)

self.args = "-S pkg1"

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_EXIST=pkg1")
self.addrule("PKG_VERSION=pkg1|1.0-2")
self.addrule("PKG_EXIST=pkg2")
self.addrule("PKG_VERSION=pkg2|1.0-2")
