self.description = "Sysupgrade with same version for local and sync packages"

sp = pmpkg("dummy")
sp.files = ["bin/foo"]
lp = pmpkg("dummy")
lp.files = ["bin/foo"]

self.addpkg2db("sync", sp)
self.addpkg2db("local", lp)

self.args = "-Su"

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_VERSION=dummy|1.0-1")
self.addrule("!FILE_MODIFIED=bin/foo")
