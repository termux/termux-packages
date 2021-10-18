self.description = "Dir->file transition filesystem conflict resolved by removal"

lp1 = pmpkg("foo")
lp1.files = ["foo/"]
self.addpkg2db("local", lp1)

sp1 = pmpkg("bar")
sp1.conflicts = ["foo"]
sp1.files = ["foo"]
self.addpkg2db("sync", sp1)

self.args = "-S %s --ask=4" % sp1.name

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_EXIST=bar")
self.addrule("!PKG_EXIST=foo")
self.addrule("FILE_EXIST=foo")
