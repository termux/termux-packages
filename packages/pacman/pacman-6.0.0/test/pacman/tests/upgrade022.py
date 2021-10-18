self.description = "Upgrade a package, with a file in 'backup' (local and new modified)"

lp = pmpkg("dummy")
lp.files = ["etc/dummy.conf"]
lp.backup = ["etc/dummy.conf*"]
self.addpkg2db("local", lp)

p = pmpkg("dummy", "1.0-2")
p.files = ["etc/dummy.conf**"]
p.backup = ["etc/dummy.conf"]
self.addpkg(p)

self.args = "-U %s" % p.filename()

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_VERSION=dummy|1.0-2")
self.addrule("!FILE_MODIFIED=etc/dummy.conf")
self.addrule("FILE_PACNEW=etc/dummy.conf")
self.addrule("!FILE_PACSAVE=etc/dummy.conf")
