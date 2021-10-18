self.description = "Remove a package with a modified file marked for backup and has existing pacsaves"

self.filesystem = ["etc/dummy.conf.pacsave",
                   "etc/dummy.conf.pacsave.1",
                   "etc/dummy.conf.pacsave.2"]

p1 = pmpkg("dummy")
p1.files = ["etc/dummy.conf*"]
p1.backup = ["etc/dummy.conf"]
self.addpkg2db("local", p1)

self.args = "-R %s" % p1.name

self.addrule("PACMAN_RETCODE=0")
self.addrule("!PKG_EXIST=dummy")
self.addrule("!FILE_EXIST=etc/dummy.conf")
self.addrule("FILE_PACSAVE=etc/dummy.conf")
self.addrule("FILE_EXIST=etc/dummy.conf.pacsave.1")
self.addrule("FILE_EXIST=etc/dummy.conf.pacsave.2")
self.addrule("FILE_EXIST=etc/dummy.conf.pacsave.3")
