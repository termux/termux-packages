self.description = "Remove a package using --assume-installed"

lp1 = pmpkg("pkg1", "1.0-1")

lp2 = pmpkg("pkg2", "1.0-1")
lp2.depends = ["pkg1=1.0"]
for p in lp1, lp2:
	self.addpkg2db("local", p);

self.args = "-R pkg1 --assume-installed pkg1=1.0"

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_EXIST=pkg2")
self.addrule("!PKG_EXIST=pkg1")
