self.description = "Install a package with cascaded dependencies"

p1 = pmpkg("dummy", "1.0-2")
p1.files = ["bin/dummy",
            "usr/man/man1/dummy.1"]
p1.depends = ["dep1"]

p2 = pmpkg("dep1")
p2.files = ["bin/dep1"]
p2.depends = ["dep2"]

p3 = pmpkg("dep2")
p3.files = ["bin/dep2"]

for p in p1, p2, p3:
	self.addpkg(p)

self.args = "-U %s" % " ".join([p.filename() for p in (p1, p2, p3)])

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_VERSION=dummy|1.0-2")
self.addrule("PKG_DEPENDS=dummy|dep1")
self.addrule("PKG_DEPENDS=dep1|dep2")
for p in p1, p2, p3:
	self.addrule("PKG_EXIST=%s" % p.name)
	for f in p.files:
		self.addrule("FILE_EXIST=%s" % f)
