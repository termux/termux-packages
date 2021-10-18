self.description = "Install a package (correct architecture, auto)"

import os
machine = os.uname()[4]

p = pmpkg("dummy")
p.files = ["bin/dummy",
           "usr/man/man1/dummy.1"]
p.arch = machine
self.addpkg(p)

self.option["Architecture"] = ['auto']

self.args = "-U %s" % p.filename()

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_EXIST=dummy")
for f in p.files:
	self.addrule("FILE_EXIST=%s" % f)
