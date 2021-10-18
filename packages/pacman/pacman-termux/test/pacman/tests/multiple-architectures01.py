self.description = "Install a package (multiple Architecture options, wrong)"

p = pmpkg("dummy")
p.files = ["bin/dummy",
           "usr/man/man1/dummy.1"]
p.arch = 'i686'
self.addpkg(p)

self.option["Architecture"] = ['i586', 'i486', 'i386']

self.args = "-U %s" % p.filename()

self.addrule("PACMAN_RETCODE=1")
self.addrule("!PKG_EXIST=dummy")
