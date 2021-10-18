self.description = "Install a package from a sync db"

sp = pmpkg("dummy")
sp.files = ["bin/dummy",
            "usr/man/man1/dummy.1"]
self.addpkg2db("sync", sp)

self.args = "-S %s" % sp.name

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_EXIST=dummy")
for f in sp.files:
	self.addrule("FILE_EXIST=%s" % f)
