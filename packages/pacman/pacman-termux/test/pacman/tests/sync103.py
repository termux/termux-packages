self.description = "Sysupgrade with a local package not existing in sync db"

sp = pmpkg("spkg")
self.addpkg2db("sync", sp)

lp = pmpkg("lpkg")
self.addpkg2db("local", lp)

self.args = "-Su"

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_EXIST=lpkg")
self.addrule("!PKG_EXIST=spkg")
