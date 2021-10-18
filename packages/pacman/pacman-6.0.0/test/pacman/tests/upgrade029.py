self.description = "Upgrade a package, with an owned file entering the pkg in 'backup'"

lp = pmpkg("dummy")
lp.files = ["usr/bin/dummy"]
self.addpkg2db("local", lp)

lp2 = pmpkg("dummy2")
lp2.files = ["etc/dummy.conf"]
self.addpkg2db("local", lp2)

p = pmpkg("dummy", "1.0-2")
p.files = ["usr/bin/dummy",
           "etc/dummy.conf*"]
p.backup = ["etc/dummy.conf"]
self.addpkg(p)

self.args = "-U %s" % p.filename()

self.addrule("PACMAN_RETCODE=1")
self.addrule("PKG_VERSION=dummy|1.0-1")
self.addrule("!FILE_PACNEW=etc/dummy.conf")
self.addrule("!FILE_PACSAVE=etc/dummy.conf")
self.addrule("FILE_EXIST=etc/dummy.conf")
