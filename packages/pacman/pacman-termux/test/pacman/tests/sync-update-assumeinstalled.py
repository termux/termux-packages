self.description = "Update a package using --assume-installed"

lp1 = pmpkg("pkg1", "1.0-1")

lp2 = pmpkg("pkg2", "1.0-1")
lp2.depends = ["pkg1=1.0"]

sp1 = pmpkg("pkg1", "2.0-1")

for p in lp1, lp2:
	self.addpkg2db("local", p);

self.addpkg2db("sync", sp1);

self.args = "-Su --assume-installed pkg1=1.0"

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_VERSION=pkg1|2.0-1")
self.addrule("PKG_EXIST=pkg2")
