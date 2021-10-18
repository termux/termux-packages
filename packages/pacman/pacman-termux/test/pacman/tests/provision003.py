self.description = "-S provision, multiple providers, one installed, different repos"

sp = pmpkg("pkg1", "1.0-2")
sp.provides = ["pkg-env"]
self.addpkg2db("sync", sp)

sp = pmpkg("pkg2", "1.0-2")
sp.provides = ["pkg-env"]
# this repo will be sorted second alphabetically
self.addpkg2db("sync2", sp)

lp = pmpkg("pkg2")
lp.provides = ["pkg-env"]
self.addpkg2db("local", lp)

self.args = "-S pkg-env"

self.addrule("PACMAN_RETCODE=0")
self.addrule("!PKG_EXIST=pkg1")
self.addrule("PKG_EXIST=pkg2")
self.addrule("PKG_VERSION=pkg2|1.0-2")
