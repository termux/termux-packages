self.description = "Install a package from a sync db with fnmatch'ed NoExtract"

sp = pmpkg("dummy")
sp.files = ["bin/dummy",
            "usr/share/man/man8",
            "usr/share/man/man1/dummy.1"]
self.addpkg2db("sync", sp)

self.option["NoExtract"] = ["usr/share/man/*"]

self.args = "-S %s" % sp.name

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_EXIST=dummy")
self.addrule("FILE_EXIST=bin/dummy")
self.addrule("!FILE_EXIST=usr/share/man/man8")
self.addrule("!FILE_EXIST=usr/share/man/man1/dummy.1")
