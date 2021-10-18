self.description = "symlink -> dir replacment"

lp1 = pmpkg("pkg1")
lp1.files = ["usr/lib/foo",
             "lib -> usr/lib/"]
self.addpkg2db("local", lp1)

lp1 = pmpkg("pkg2")
lp1.files = ["usr/lib/bar"]
self.addpkg2db("local", lp1)

sp = pmpkg("pkg1", "1.0-2")
sp.files = ["lib/bar"]
self.addpkg2db("sync", sp)

self.args = "-S %s" % sp.name

self.addrule("PACMAN_RETCODE=0")
self.addrule("FILE_TYPE=lib|dir")
self.addrule("FILE_TYPE=lib/bar|file")
