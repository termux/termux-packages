self.description = "Sysupgrade with a newer local package"

sp = pmpkg("dummy", "0.9-1")
sp.files = ["bin/foo", "bin/bar"]
lp = pmpkg("dummy")
lp.files = ["bin/foo", "bin/baz"]

self.addpkg2db("sync", sp)
self.addpkg2db("local", lp)

self.args = "-Su"

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_VERSION=dummy|1.0-1")
self.addrule("FILE_EXIST=bin/foo")
self.addrule("FILE_EXIST=bin/baz")
self.addrule("!FILE_EXIST=bin/bar")
