self.description = "Get URL on package from a sync db"

sp = pmpkg("dummy")
sp.files = ["bin/dummy",
            "usr/man/man1/dummy.1"]
self.addpkg2db("sync", sp)

self.args = "-Sp %s" % sp.name

self.addrule("PACMAN_RETCODE=0")
self.addrule("PACMAN_OUTPUT=%s" % sp.name)
self.addrule("PACMAN_OUTPUT=file://")
