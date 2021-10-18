self.description = "Filesystem conflict on upgrade with symlinks"

self.filesystem = ["share", "usr/lib/", "lib -> usr/lib/"]

lp1 = pmpkg("foo", "1-1")
lp1.files = ["lib/"]
self.addpkg2db("local", lp1)

sp1 = pmpkg("foo", "1-2")
# share/ causes the file order to change upon path resolution
sp1.files = ["lib/", "share"]
self.addpkg2db("sync", sp1)

self.args = "-S %s" % sp1.name

self.addrule("PACMAN_RETCODE=1")
self.addrule("PKG_EXIST=foo|1-1")
