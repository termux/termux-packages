self.description = "Dir->file transition filesystem conflict resolved by removal (with subdirectory)"

lp1 = pmpkg("foo")
lp1.files = ["foo/bar/"]
self.addpkg2db("local", lp1)

sp1 = pmpkg("foo", "2-1")
sp1.conflicts = ["foo"]
sp1.files = ["foo"]
self.addpkg2db("sync", sp1)

self.args = "-S %s" % sp1.name

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_VERSION=foo|2-1")
self.addrule("FILE_EXIST=foo")
