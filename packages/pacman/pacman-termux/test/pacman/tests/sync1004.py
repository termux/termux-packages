self.description = "Induced removal would break dependency (2)"

sp1 = pmpkg("pkg1")
sp1.conflicts = [ "depend" ]
self.addpkg2db("sync", sp1)

sp2 = pmpkg("pkg2")
sp2.depends = ["depend"]
self.addpkg2db("sync", sp2)

lp = pmpkg("depend")
self.addpkg2db("local", lp)

self.args = "-S pkg1 pkg2 --ask=4"

self.addrule("PACMAN_RETCODE=1")
self.addrule("PKG_EXIST=depend")

