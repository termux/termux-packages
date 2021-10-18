self.description = "Copy reason (to-be-replaced -> replacement)"

sp = pmpkg("libfoo-ng")
sp.replaces = [ "libfoo" ]
self.addpkg2db("sync", sp)

lp = pmpkg("libfoo")
lp.reason = 1
self.addpkg2db("local", lp)

self.args = "-Su"

self.addrule("PACMAN_RETCODE=0")
self.addrule("!PKG_EXIST=libfoo")
self.addrule("PKG_EXIST=libfoo-ng")
self.addrule("PKG_REASON=libfoo-ng|1")
