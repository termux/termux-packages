self.description = "removal of directory symlink when another package has file in its path"
# Note: this situation means that the filesystem and local db are out of sync

lp1 = pmpkg("pkg1")
lp1.files = ["usr/lib/foo",
             "lib -> usr/lib"]
self.addpkg2db("local", lp1)

lp2 = pmpkg("pkg2")
lp2.files = ["lib/bar"]
self.addpkg2db("local", lp2)

p = pmpkg("pkg1", "1.0-2")
p.files = ["usr/lib/foo"]
self.addpkg2db("sync", p)

self.args = "-S pkg1"

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_VERSION=pkg1|1.0-2")
self.addrule("FILE_EXIST=usr/lib/bar")
self.addrule("!FILE_EXIST=lib/bar")
