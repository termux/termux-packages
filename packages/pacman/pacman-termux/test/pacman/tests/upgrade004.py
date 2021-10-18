self.description = "Upgrade a package (not installed)"

p = pmpkg("dummy")
p.files = ["bin/dummy",
           "usr/man/man1/dummy.1"]
self.addpkg(p)

self.args = "-U %s" % p.filename()

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_EXIST=dummy")
for f in p.files:
	self.addrule("FILE_EXIST=%s" % f)
