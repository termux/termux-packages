self.description = "Upgrade a package, with a backup file in the NEW package only"

lp = pmpkg("dummy")
lp.files = ["etc/dummy.conf*"]
self.addpkg2db("local", lp)

p = pmpkg("dummy", "1.1-1")
p.files = ["etc/dummy.conf"]
p.backup = ["etc/dummy.conf"]
self.addpkg(p)

self.args = "-U %s" % p.filename()

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_VERSION=dummy|1.1-1")
self.addrule("!FILE_MODIFIED=etc/dummy.conf")
# Do we want this pacnew or not?
self.addrule("FILE_PACNEW=etc/dummy.conf")
self.addrule("!FILE_PACSAVE=etc/dummy.conf")
