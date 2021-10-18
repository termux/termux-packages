self.description = "FS#7524, versioned dependency resolving with conflict"

sp1 = pmpkg("compiz-git", "20070626-1")
sp1.depends = ["cairo"]
sp1.groups = ["compiz-fusion"]
self.addpkg2db("sync", sp1)

sp2 = pmpkg("ccsm-git", "20070626-1")
sp2.depends = ["pygtk"]
sp2.groups = ["compiz-fusion"]
self.addpkg2db("sync", sp2)

sp3 = pmpkg("pygtk", "2.22.0-1")
sp3.depends = ["pycairo"]
self.addpkg2db("sync", sp3)

sp4 = pmpkg("pycairo", "1.4.0-2")
sp4.depends = ["cairo>=1.4.6-2"]
self.addpkg2db("sync", sp4)

sp5 = pmpkg("cairo", "1.4.6-2")
self.addpkg2db("sync", sp5)

lp1 = pmpkg("cairo-lcd", "1.4.6-1")
lp1.provides = "cairo"
lp1.conflicts = ["cairo"]
self.addpkg2db("local", lp1)

self.args = "-S compiz-fusion"

self.addrule("PACMAN_RETCODE=1")
self.addrule("PKG_EXIST=cairo-lcd")
self.addrule("PKG_VERSION=cairo-lcd|1.4.6-1")
self.addrule("!PKG_EXIST=cairo")
self.addrule("!PKG_EXIST=compiz-git")
self.addrule("!PKG_EXIST=ccsm-git")
self.addrule("!PKG_EXIST=pygtk")
self.addrule("!PKG_EXIST=pycairo")
