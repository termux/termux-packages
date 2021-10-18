self.description = "Choose a dependency satisfier (target-list vs. database)"

sp1 = pmpkg("pkg1")
sp1.depends = ["dep"]

sp2 = pmpkg("pkg2")
sp2.provides = ["dep"]

sp3 = pmpkg("pkg3")
sp3.provides = ["dep"]

for p in sp1, sp2, sp3:
        self.addpkg2db("sync", p)

self.args = "-S pkg1 pkg3"

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_EXIST=pkg1")
self.addrule("!PKG_EXIST=pkg2")
self.addrule("PKG_EXIST=pkg3")
