self.description = "Install a package with a file in NoExtract"

p = pmpkg("dummy")
p.files = ["bin/dummy",
           "usr/man/man1/dummy.1"]
self.addpkg(p)

self.option["NoExtract"] = ["usr/man/man1/dummy.1"]

self.args = "-U %s" % p.filename()

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_EXIST=dummy")
self.addrule("FILE_EXIST=bin/dummy")
self.addrule("!FILE_EXIST=usr/man/man1/dummy.1")
