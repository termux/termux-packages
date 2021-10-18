self.description = "-Suu"

sp = pmpkg("dummy", "0.9-1")
lp = pmpkg("dummy", "1.0-1")

self.addpkg2db("sync", sp)
self.addpkg2db("local", lp)

self.args = "-Suu"

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_VERSION=dummy|0.9-1")
