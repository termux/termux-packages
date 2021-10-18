self.description = "-D --asdeps"

lp = pmpkg("pkg")
lp.reason = 0
self.addpkg2db("local", lp)

self.args = "-D pkg --asdeps"

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_EXIST=pkg")
self.addrule("PKG_REASON=pkg|1")
