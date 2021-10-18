self.description = "incoming package replaces symlink with directory"

lp = pmpkg("pkg1")
lp.files = ["usr/lib/foo",
            "lib -> usr/lib"]
self.addpkg2db("local", lp)

p1 = pmpkg("pkg2")
p1.files = ["lib/foo"]
p1.conflicts = ["pkg1"]
self.addpkg2db("sync", p1)

self.args = "-S pkg2 --ask=4"

self.addrule("PACMAN_RETCODE=0")
self.addrule("!PKG_EXIST=pkg1")
self.addrule("PKG_EXIST=pkg2")
self.addrule("FILE_TYPE=lib|dir")
