self.description = "Install a package with an existing file matching an --overwrite pattern"

p = pmpkg("dummy")
p.files = ["foobar"]
self.addpkg(p)

self.filesystem = ["foobar*"]

self.args = "-U --overwrite=foobar %s" % p.filename()

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_EXIST=dummy")
self.addrule("FILE_MODIFIED=foobar")
