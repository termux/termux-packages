self.description = "fileconflict error cancels the sync transaction after the removal part"

sp = pmpkg("pkg1")
sp.replaces = ["pkg3"]
sp.files = ["dir/file"]
self.addpkg2db("sync", sp)

lp1 = pmpkg("pkg3")
self.addpkg2db("local", lp1)

lp2 = pmpkg("pkg2")
lp2.files = ["dir/file"]
self.addpkg2db("local", lp2)

self.args = "-Su"

self.addrule("PACMAN_RETCODE=1")
self.addrule("!PKG_EXIST=pkg1")
self.addrule("PKG_EXIST=pkg2")
self.addrule("PKG_EXIST=pkg3")
