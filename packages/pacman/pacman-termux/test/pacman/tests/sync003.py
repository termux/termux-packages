self.description = "Install a package from a sync db, with a filesystem conflict"

sp = pmpkg("dummy")
sp.files = ["bin/dummy",
            "usr/man/man1/dummy.1"]
self.addpkg2db("sync", sp)

self.filesystem = ["bin/dummy"]

self.args = "-S %s" % sp.name

self.addrule("PACMAN_RETCODE=1")
self.addrule("!PKG_EXIST=dummy")
