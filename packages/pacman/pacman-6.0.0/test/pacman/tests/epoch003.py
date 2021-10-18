self.description = "Sysupgrade with an epoch package overriding a force package"

sp = pmpkg("dummy", "2:1.4-1")
self.addpkg2db("sync", sp)

lp = pmpkg("dummy", "1:2.0-1")
self.addpkg2db("local", lp)

self.args = "-Su"

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_VERSION=dummy|2:1.4-1")
