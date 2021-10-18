self.description = "dir->symlink change during package upgrade (conflict)"

p1 = pmpkg("pkg1", "1.0-1")
p1.files = ["test/",
            "test/file1",
            "test/dir/file1",
            "test/dir/file2"]
self.addpkg2db("local", p1)

p2 = pmpkg("pkg2")
p2.files = ["test/dir/file3"]
self.addpkg2db("local", p2)

p3 = pmpkg("pkg1", "2.0-1")
p3.files = ["test2/",
            "test2/file3",
            "test -> test2"]
self.addpkg2db("sync", p3)

self.args = "-S pkg1"

self.addrule("PACMAN_RETCODE=1")
self.addrule("PKG_EXIST=pkg1")
self.addrule("PKG_VERSION=pkg1|1.0-1")
