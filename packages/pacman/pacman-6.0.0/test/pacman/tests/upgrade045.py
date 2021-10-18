self.description = "FS#9235, backup file is broken symlink"

lp = pmpkg("foo")
lp.files = ["etc/foo.cfg -> etc/foo.cfg"]
lp.backup = ["etc/foo.cfg"]
self.addpkg2db("local", lp)

p1 = pmpkg("foo", "1.0-2")
p1.files = ["etc/foo.cfg*"]
p1.backup = ["etc/foo.cfg"]
self.addpkg(p1)

self.args = "-U %s" % p1.filename()

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_VERSION=foo|1.0-2")
self.addrule("LINK_EXIST=etc/foo.cfg")
self.addrule("FILE_EXIST=etc/foo.cfg.pacnew")
