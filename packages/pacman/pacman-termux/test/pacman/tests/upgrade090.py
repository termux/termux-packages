self.description = "-U syncdeps test"

p1 = pmpkg("pkg1", "1.0-2")
p1.files = ["bin/pkg1"]

p2 = pmpkg("pkg2", "1.0-2")
p2.depends = ["dep"]

p3 = pmpkg("pkg3", "1.0-2")
p3.depends = ["unres"]

for p in p1, p2, p3:
	self.addpkg(p)

sp = pmpkg("dep")
sp.files = ["bin/dep"]
self.addpkg2db("sync", sp)

self.args = "-U %s --ask=16" % " ".join([p.filename() for p in (p1, p2, p3)])

self.addrule("PACMAN_RETCODE=0")
for p in p1, p2, sp:
	self.addrule("PKG_EXIST=%s" % p.name)
	for f in p.files:
		self.addrule("FILE_EXIST=%s" % f)
self.addrule("PKG_VERSION=pkg1|1.0-2")
self.addrule("PKG_VERSION=pkg2|1.0-2")
self.addrule("!PKG_EXIST=pkg3")
