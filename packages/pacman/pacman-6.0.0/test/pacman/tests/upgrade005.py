self.description = "Install a set of three packages"

p1 = pmpkg("pkg1")
p1.files = ["bin/pkg1",
            "usr/man/man1/pkg1.1"]

p2 = pmpkg("pkg2", "2.0-1")
p2.files = ["bin/pkg2",
            "usr/man/man1/pkg2.1"]

p3 = pmpkg("pkg3", "3.0-1")
p3.files = ["bin/pkg3", "usr/man/man1/pkg3.1"]

for p in p1, p2, p3:
	self.addpkg(p)

self.args = "-U %s" % " ".join([p.filename() for p in (p1, p2, p3)])

self.addrule("PACMAN_RETCODE=0")
for p in p1, p2, p3:
	self.addrule("PKG_EXIST=%s" % p.name)
	for f in p.files:
		self.addrule("FILE_EXIST=%s" % f)
