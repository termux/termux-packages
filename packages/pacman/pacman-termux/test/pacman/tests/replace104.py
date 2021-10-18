self.description = "Sysupgrade with multiple replaces"

sdep = pmpkg("common-dep", "1.1-1")
self.addpkg2db("sync", sdep)

for i in range(3):
	sp = pmpkg("split%d" % i, "2.0-1")
	sp.depends = ["common-dep"]
	sp.replaces = ["notsplit"]
	self.addpkg2db("sync", sp)

ldep = pmpkg("common-dep")
self.addpkg2db("local", ldep)

lp = pmpkg("notsplit")
lp.depends = ["common-dep"]
self.addpkg2db("local", lp)

self.args = "-Su"

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_VERSION=common-dep|1.1-1")
self.addrule("!PKG_EXIST=notsplit")
for i in range(3):
	self.addrule("PKG_VERSION=split%d|2.0-1" % i)
