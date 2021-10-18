self.description = "File conflict between package with symlink and package with real path and filesystem (reversed)"

self.filesystem = ["usr/lib/", "lib -> usr/lib/"]

lp1 = pmpkg("foo")
lp1.files = ["usr/", "usr/lib/", "usr/lib/file"]
self.addpkg2db("local", lp1)

sp1 = pmpkg("bar")
sp1.conflicts = ["foo"]
sp1.files = ["lib/", "lib/file"]
self.addpkg2db("sync", sp1)

self.args = "-S %s --ask=4" % sp1.name

self.addrule("PACMAN_RETCODE=1")
self.addrule("PKG_EXIST=foo")
self.addrule("!PKG_EXIST=bar")
