self.description = "incoming package replaces symlink with directory (order 2)"

lp = pmpkg("pkg2")
lp.files = ["usr/lib/foo",
            "lib -> usr/lib"]
self.addpkg2db("local", lp)

p1 = pmpkg("pkg1")
p1.files = ["lib/bar"]
self.addpkg2db("sync", p1)

p2 = pmpkg("pkg2", "1.0-2")
p2.files = ["usr/lib/foo"]
self.addpkg2db("sync", p2)

self.args = "-S pkg1 pkg2"

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_VERSION=pkg2|1.0-2")
self.addrule("PKG_EXIST=pkg1")
self.addrule("FILE_TYPE=lib|dir")
