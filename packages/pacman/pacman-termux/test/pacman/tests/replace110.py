self.description = "Replace a package with a file in 'backup' (local modified)"
# FS#24543

lp = pmpkg("dummy")
lp.files = ["etc/dummy.conf*", "bin/dummy"]
lp.backup = ["etc/dummy.conf"]
self.addpkg2db("local", lp)

sp = pmpkg("replacement")
sp.replaces = ["dummy"]
sp.files = ["etc/dummy.conf", "bin/dummy*"]
sp.backup = ["etc/dummy.conf"]
self.addpkg2db("sync", sp)

self.args = "-Su"

self.addrule("!PKG_EXIST=dummy")
self.addrule("PKG_EXIST=replacement")

self.addrule("FILE_EXIST=etc/dummy.conf")
self.addrule("!FILE_MODIFIED=etc/dummy.conf")
self.addrule("!FILE_PACNEW=etc/dummy.conf")
self.addrule("!FILE_PACSAVE=etc/dummy.conf")

self.addrule("FILE_EXIST=bin/dummy")

self.expectfailure = True
