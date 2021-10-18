# TODO: these are labeled as database packages because they sure seem to me to
# be database-type operations. In their current implementation however they are
# calling -U and -R rather than -D. Obviously the tests will need to be updated
# if this changes.
self.description = "Upgrade a package with --dbonly, no files touched"

lp = pmpkg("dummy")
lp.files = ["bin/dummy",
           "usr/man/man1/dummy.1"]
self.addpkg2db("local", lp)

p = pmpkg("dummy", "2.0-1")
p.files = ["bin/dummy",
           "bin/dummy2",
           "usr/man/man1/dummy.1"]
self.addpkg(p)

self.args = "-U --dbonly %s" % p.filename()

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_EXIST=dummy")
self.addrule("PKG_VERSION=dummy|2.0-1")
for f in lp.files:
	self.addrule("FILE_EXIST=%s" % f)
self.addrule("!FILE_EXIST=bin/dummy2")
