self.description = "Sysupgrade with a replacement for a local package out of date"

sp1 = pmpkg("pkg1")
sp1.replaces = ["pkg2"]
sp2 = pmpkg("pkg2", "2.0-1")

for p in sp1, sp2:
	self.addpkg2db("sync", p)

lp = pmpkg("pkg2")

self.addpkg2db("local", lp)

self.args = "-Su"

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_EXIST=pkg1")
self.addrule("!PKG_EXIST=pkg2")
