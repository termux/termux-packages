self.description = "-S literal with provision of same name installed"

sp = pmpkg("provision", "1.0-2")
sp.provides = ["literal"]
sp.conflicts = ["literal"]
self.addpkg2db("sync", sp)

sp = pmpkg("literal", "1.0-2")
self.addpkg2db("sync2", sp)

lp = pmpkg("provision")
lp.provides = ["literal"]
lp.conflicts = ["literal"]
self.addpkg2db("local", lp)

self.args = "-S literal --ask=4"

self.addrule("PACMAN_RETCODE=0")
self.addrule("!PKG_EXIST=provision")
self.addrule("PKG_EXIST=literal")
self.addrule("PKG_VERSION=literal|1.0-2")
