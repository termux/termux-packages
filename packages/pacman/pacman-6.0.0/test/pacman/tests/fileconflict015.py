self.description = "conflict between a directory and a file"

p1 = pmpkg("pkg1")
p1.files = ["foo/"]
self.addpkg2db("sync", p1)

p2 = pmpkg("pkg2")
p2.files = ["foo"]
self.addpkg2db("sync", p2)

self.args = "-S pkg1 pkg2"

self.addrule("PACMAN_RETCODE=1")
self.addrule("!PKG_EXIST=pkg1")
self.addrule("!PKG_EXIST=pkg2")
