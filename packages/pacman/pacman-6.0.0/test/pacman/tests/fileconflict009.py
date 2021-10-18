self.description = "dir->symlink change during package upgrade (directory conflict)"

lp1 = pmpkg("pkg1")
lp1.files = ["dir/"]
self.addpkg2db("local", lp1)

lp2 = pmpkg("pkg2")
lp2.files = ["dir/"]
self.addpkg2db("local", lp2)

p = pmpkg("pkg1", "1.0-2")
p.files = ["dir -> /usr/dir"]
self.addpkg2db("sync", p)

self.args = "-S pkg1"

self.addrule("PACMAN_RETCODE=1")
self.addrule("PKG_VERSION=pkg1|1.0-1")
self.addrule("PKG_VERSION=pkg2|1.0-1")
self.addrule("DIR_EXIST=dir/")
