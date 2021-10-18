self.description = "Backup file permissions test (same as orig)"

lp = pmpkg("filesystem")
lp.files = ["etc/profile|666"]
lp.backup = ["etc/profile*"]
self.addpkg2db("local", lp)

p = pmpkg("filesystem", "1.0-2")
p.files = ["etc/profile|666**"]
p.backup = ["etc/profile"]
self.addpkg(p)

self.args = "-U %s" % p.filename()

self.addrule("PACMAN_RETCODE=0")
self.addrule("!FILE_PACSAVE=etc/profile")
self.addrule("FILE_PACNEW=etc/profile")
self.addrule("FILE_EXIST=etc/profile")
self.addrule("FILE_MODE=etc/profile|666")
self.addrule("FILE_MODE=etc/profile.pacnew|666")
