self.description = "-D --asexplicit"

lp = pmpkg("pkg")
lp.reason = 1
self.addpkg2db("local", lp)

self.args = "-D pkg --asexplicit"

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_EXIST=pkg")
self.addrule("PKG_REASON=pkg|0")
