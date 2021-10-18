# If someone else can come up with a better name, please do so
self.description = "stonecrest's problem"

sp = pmpkg("dummy", "1.1-1")
self.addpkg2db("sync", sp)

lp1 = pmpkg("dummy", "1.0-1")
self.addpkg2db("local", lp1)

lp2 = pmpkg("pkg")
lp2.depends = [ "dummy=1.0" ]
self.addpkg2db("local", lp2)

self.args = "-Su"

self.addrule("!PACMAN_RETCODE=0")
self.addrule("!PKG_VERSION=dummy|1.1-1")
