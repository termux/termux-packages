self.description = "Upgrade a package from a sync db"

sp = pmpkg("dummy", "1.0-2")
sp.files = ["bin/dummy",
            "usr/man/man1/dummy.1"]
self.addpkg2db("sync", sp)

lp = pmpkg("dummy")
lp.files = ["bin/dummy",
            "usr/man/man1/dummy.1"]
self.addpkg2db("local", lp)

self.args = "-S %s" % sp.name

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_VERSION=dummy|1.0-2")
for f in lp.files:
	self.addrule("FILE_MODIFIED=%s" % f)
