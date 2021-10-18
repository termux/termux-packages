self.description = "File relocation between two packages (reverse order)"

lp1 = pmpkg("dummy")
lp1.files = ["bin/dummy"]

lp2 = pmpkg("foobar")
lp2.files = ["bin/foobar",
             "usr/share/file"]

for p in lp1, lp2:
	self.addpkg2db("local", p)

p1 = pmpkg("dummy")
p1.files = ["bin/dummy",
            "usr/share/file"]

p2 = pmpkg("foobar")
p2.files = ["bin/foobar"]

for p in p1, p2:
	self.addpkg(p)

self.args = "-U %s" % " ".join([p.filename() for p in (p1, p2)])

self.addrule("PACMAN_RETCODE=0")
for p in p1, p2:
	self.addrule("PKG_EXIST=%s" % p.name)
self.addrule("FILE_MODIFIED=bin/dummy")
self.addrule("FILE_MODIFIED=bin/foobar")
self.addrule("FILE_EXIST=usr/share/file")
self.addrule("FILE_MODIFIED=usr/share/file")
