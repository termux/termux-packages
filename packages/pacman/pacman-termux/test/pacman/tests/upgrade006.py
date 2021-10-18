self.description = "Upgrade a package with several files"

lp = pmpkg("dummy")
lp.files = ["usr/share/file_%d" % n for n in range(250, 750)]
self.addpkg2db("local", lp)

p = pmpkg("dummy", "1.1-1")
p.files = ["usr/share/file_%d" % n for n in range(600, 1000)]
self.addpkg(p)

self.args = "-U %s" % p.filename()

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_VERSION=dummy|1.1-1")
self.addrule("!FILE_EXIST=usr/share/file_250")
self.addrule("!FILE_EXIST=usr/share/file_599")
self.addrule("FILE_EXIST=usr/share/file_600")
self.addrule("FILE_EXIST=usr/share/file_999")
