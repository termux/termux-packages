self.description = "FS#8156- conflict between directory and incoming symlink"

p1 = pmpkg("pkg1")
p1.files = ["test/",
            "test/file"]
self.addpkg2db("local", p1)

p2 = pmpkg("pkg2")
p2.files = ["test2/",
            "test2/file2",
            "test -> test2"]
self.addpkg2db("sync", p2)

self.args = "-S pkg2"

self.addrule("PACMAN_RETCODE=1")
self.addrule("PKG_EXIST=pkg1")
self.addrule("!PKG_EXIST=pkg2")
