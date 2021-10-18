self.description = "file conflict with same effective path across packages (directory symlink - deep)"

lp1 = pmpkg("filesystem", "1.0-1")
lp1.files = ["usr/",
             "usr/lib/",
             "lib -> usr/lib/"]
self.addpkg2db("local", lp1)

p1 = pmpkg("pkg1")
p1.files = ["lib/",
            "lib/foo/",
            "lib/foo/bar"]
self.addpkg2db("sync", p1)

p2 = pmpkg("pkg2")
p2.files = ["usr/",
            "usr/lib/",
            "usr/lib/foo/",
            "usr/lib/foo/bar"]
self.addpkg2db("sync", p2)

self.args = "-S pkg1 pkg2"

self.addrule("PACMAN_RETCODE=1")
self.addrule("!PKG_EXIST=pkg1")
self.addrule("!PKG_EXIST=pkg2")
