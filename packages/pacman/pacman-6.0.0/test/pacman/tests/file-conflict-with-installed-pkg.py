self.description = "File conflict with an installed package"

lp = pmpkg("foobar")
lp.files = ["conflicting-file"]
self.addpkg2db("local", lp)

p1 = pmpkg("pkg1")
p1.files = ["conflicting-file"]
self.addpkg(p1)

self.args = "-U %s" % (p1.filename())

self.addrule("!PACMAN_RETCODE=0")
self.addrule("PKG_EXIST=foobar")
self.addrule("!PKG_EXIST=pkg1")
self.addrule("FILE_EXIST=conflicting-file")
self.addrule("PACMAN_OUTPUT=foobar")
