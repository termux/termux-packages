self.description = "dir->symlink change during package upgrade (no conflict)"

p1 = pmpkg("pkg1", "1.0-1")
p1.files = ["test/",
            "test/file"]
self.addpkg2db("local", p1)

p2 = pmpkg("pkg1", "2.0-1")
p2.files = ["test2/",
            "test2/file2",
            "test -> test2"]
self.addpkg2db("sync", p2)

self.args = "-S pkg1"

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_EXIST=pkg1")
self.addrule("PKG_VERSION=pkg1|2.0-1")
self.addrule("FILE_TYPE=test|link")
