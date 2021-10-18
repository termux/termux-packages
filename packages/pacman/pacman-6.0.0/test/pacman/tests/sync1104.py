self.description = "Don't update (reinstall) a replaced package"

lp = pmpkg("old", "1-1")
self.addpkg2db("local", lp)

p1 = pmpkg("new")
p1.provides = ["old"]
p1.replaces = ["old"]
self.addpkg2db("sync1", p1)

p2 = pmpkg("old", "1-2")
self.addpkg2db("sync2", p2)

self.args = "-Su"

self.addrule("PACMAN_RETCODE=0")
self.addrule("!PKG_EXIST=old")
self.addrule("PKG_EXIST=new")
