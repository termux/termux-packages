self.description = "Sysupgrade with a sync package replacing a local one"

sp = pmpkg("pkg2")
sp.replaces = ["pkg1"]

self.addpkg2db("sync", sp)

lp = pmpkg("pkg1")

self.addpkg2db("local", lp)

self.args = "-Su"

self.addrule("PACMAN_RETCODE=0")
self.addrule("!PKG_EXIST=pkg1")
self.addrule("PKG_EXIST=pkg2")
