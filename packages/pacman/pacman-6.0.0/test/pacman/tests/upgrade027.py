self.description = "Upgrade a package, with a file entering the pkg in 'backup' (changed)"

self.filesystem = ["etc/dummy.conf"]

lp = pmpkg("dummy")
lp.files = ["usr/bin/dummy"]
self.addpkg2db("local", lp)

p = pmpkg("dummy", "1.0-2")
p.files = ["usr/bin/dummy",
           "etc/dummy.conf*"]
p.backup = ["etc/dummy.conf"]
self.addpkg(p)

self.args = "-U %s" % p.filename()

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_VERSION=dummy|1.0-2")
self.addrule("FILE_PACNEW=etc/dummy.conf")
self.addrule("!FILE_PACSAVE=etc/dummy.conf")
self.addrule("FILE_EXIST=etc/dummy.conf")
