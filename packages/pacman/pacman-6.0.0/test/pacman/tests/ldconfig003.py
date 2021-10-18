self.description = "Make sure ldconfig runs on a sync operation"

sp = pmpkg("dummy")
self.addpkg2db("sync", sp)

self.args = "-S %s" % sp.name

self.addrule("PACMAN_RETCODE=0")
self.addrule("FILE_EXIST=etc/ld.so.cache")
