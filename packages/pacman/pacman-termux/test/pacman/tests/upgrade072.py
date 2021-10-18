self.description = "Install a package with a missing dependency (nodeps)"

p = pmpkg("dummy")
p.files = ["bin/dummy",
           "usr/man/man1/dummy.1"]
p.depends = ["dep1"]
self.addpkg(p)

self.args = "-Udd %s" % p.filename()

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_EXIST=dummy")
self.addrule("PKG_DEPENDS=dummy|dep1")
for f in p.files:
	self.addrule("FILE_EXIST=%s" % f)
