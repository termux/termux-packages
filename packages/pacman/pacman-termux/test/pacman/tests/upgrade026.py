self.description = "Upgrade a package, with a file leaving the pkg but staying in 'backup'"

lp = pmpkg("dummy")
lp.files = ["etc/dummy.conf*"]
lp.backup = ["etc/dummy.conf"]
self.addpkg2db("local", lp)

p = pmpkg("dummy", "1.0-2")
p.backup = ["etc/dummy.conf"]
self.addpkg(p)

self.args = "-U %s" % p.filename()

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_VERSION=dummy|1.0-2")
self.addrule("FILE_PACSAVE=etc/dummy.conf")
self.addrule("!FILE_PACNEW=etc/dummy.conf")
self.addrule("!FILE_EXIST=etc/dummy.conf")
