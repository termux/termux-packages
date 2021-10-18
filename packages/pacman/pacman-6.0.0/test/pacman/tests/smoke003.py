self.description = "Remove a thousand packages in a single transaction"

for i in range(1000):
	p = pmpkg("pkg%03dname" % i)
	p.files = ["usr/share/pkg%03d/file" % i]
	self.addpkg2db("local", p)

pkglist = ["pkg%03dname" % i for i in range(100, 1000)]
self.args = "-R %s" % " ".join(pkglist)

self.addrule("PACMAN_RETCODE=0")
# picked random packages to test for, since a loop is too much to handle
self.addrule("PKG_EXIST=pkg000name")
self.addrule("PKG_EXIST=pkg050name")
self.addrule("PKG_EXIST=pkg099name")
self.addrule("!PKG_EXIST=pkg100name")
self.addrule("!PKG_EXIST=pkg383name")
self.addrule("!PKG_EXIST=pkg674name")
self.addrule("!PKG_EXIST=pkg999name")
