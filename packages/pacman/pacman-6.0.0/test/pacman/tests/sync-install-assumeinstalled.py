self.description = "Install a package using --assume-installed"

sp1 = pmpkg("pkg2", "2.0-1")
sp1.depends = ["pkg1"]

self.addpkg2db("sync", sp1);

self.args = "-S pkg2 --assume-installed pkg1"

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_EXIST=pkg2")
