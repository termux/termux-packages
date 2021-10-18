self.description = "Sysupgrade with a sync package having higher epoch"

sp = pmpkg("dummy", "1:1.0-1")
self.addpkg2db("sync", sp)

lp = pmpkg("dummy", "1.1-1")
self.addpkg2db("local", lp)

self.args = "-Su"

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_VERSION=dummy|1:1.0-1")
