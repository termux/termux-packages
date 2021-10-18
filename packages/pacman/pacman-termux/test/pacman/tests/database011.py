# TODO: these are labeled as database packages because they sure seem to me to
# be database-type operations. In their current implementation however they are
# calling -U and -R rather than -D. Obviously the tests will need to be updated
# if this changes.
self.description = "Install a package with --dbonly, no files touched"

p = pmpkg("dummy")
p.files = ["bin/dummy",
           "usr/man/man1/dummy.1"]
self.addpkg(p)

self.args = "-U --dbonly %s" % p.filename()

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_EXIST=dummy")
for f in p.files:
	self.addrule("!FILE_EXIST=%s" % f)
