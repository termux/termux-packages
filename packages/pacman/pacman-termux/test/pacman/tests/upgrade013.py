self.description = "Install two packages with a conflicting file"

p1 = pmpkg("dummy")
p1.files = ["bin/dummy",
            "usr/man/man1/dummy.1",
            "usr/common"]

p2 = pmpkg("foobar")
p2.files = ["bin/foobar",
            "usr/man/man1/foobar.1",
            "usr/common"]

for p in p1, p2:
	self.addpkg(p)

self.args = "-U %s" % " ".join([p.filename() for p in (p1, p2)])

self.addrule("PACMAN_RETCODE=1")
self.addrule("!PKG_EXIST=dummy")
self.addrule("!PKG_EXIST=foobar")
