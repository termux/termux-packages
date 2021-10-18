self.description = "Install a package from a sync db with NoExtract"

sp = pmpkg("dummy")
sp.files = ["bin/dummy",
            "usr/man/man1/dummy.1"]
self.addpkg2db("sync", sp)

self.option["NoExtract"] = ["usr/man/man1/dummy.1"]

self.args = "-S %s" % sp.name

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_EXIST=dummy")
self.addrule("FILE_EXIST=bin/dummy")
self.addrule("!FILE_EXIST=usr/man/man1/dummy.1")
