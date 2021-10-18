self.description = "Install a package ('any' architecture)"

p = pmpkg("dummy")
p.files = ["bin/dummy",
           "usr/man/man1/dummy.1"]
p.arch = 'any'
self.addpkg(p)

self.option["Architecture"] = ['auto']

self.args = "-U %s" % p.filename()

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_EXIST=dummy")
for f in p.files:
	self.addrule("FILE_EXIST=%s" % f)
