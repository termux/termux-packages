self.description = "Remove a package with an unchanged file marked for backup"

p1 = pmpkg("dummy")
p1.files = ["etc/dummy.conf"]
p1.backup = ["etc/dummy.conf"]
self.addpkg2db("local", p1)

self.args = "-R %s" % p1.name

self.addrule("PACMAN_RETCODE=0")
self.addrule("!PKG_EXIST=dummy")
self.addrule("!FILE_EXIST=etc/dummy.conf")
self.addrule("!FILE_PACSAVE=etc/dummy.conf")
