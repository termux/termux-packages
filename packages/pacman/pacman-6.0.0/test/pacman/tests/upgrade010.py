self.description = "Upgrade a package, with a file in NoUpgrade"

lp = pmpkg("dummy")
lp.files = ["etc/dummy.conf"]
self.addpkg2db("local", lp)

p = pmpkg("dummy", "1.0-2")
p.files = ["etc/dummy.conf"]
self.addpkg(p)

self.option["NoUpgrade"] = ["etc/dummy.conf"]

self.args = "-U %s" % p.filename()

self.addrule("PKG_VERSION=dummy|1.0-2")
self.addrule("!FILE_MODIFIED=etc/dummy.conf")
self.addrule("FILE_PACNEW=etc/dummy.conf")
self.addrule("!FILE_PACSAVE=etc/dummy.conf")
