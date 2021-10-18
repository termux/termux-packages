self.description = "Upgrade a package, with a file in NoUpgrade"

sp = pmpkg("dummy", "1.0-2")
sp.files = ["etc/dummy.conf"]
self.addpkg2db("sync", sp)

lp = pmpkg("dummy")
lp.files = ["etc/dummy.conf"]
self.addpkg2db("local", lp)

self.option["NoUpgrade"] = ["etc/dummy.conf"]

self.args = "-S %s" % sp.name

self.addrule("PKG_VERSION=dummy|1.0-2")
self.addrule("!FILE_MODIFIED=etc/dummy.conf")
self.addrule("FILE_PACNEW=etc/dummy.conf")
self.addrule("!FILE_PACSAVE=etc/dummy.conf")
