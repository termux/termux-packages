self.description = "Remove a package with several files"

p = pmpkg("foo")
p.files = ["usr/share/file_%d" % n for n in range(1000)]
self.addpkg2db("local", p)

self.args = "-R %s" % p.name

self.addrule("PACMAN_RETCODE=0")
self.addrule("!PKG_EXIST=foo")
self.addrule("!FILE_EXIST=usr/share/file_0")
self.addrule("!FILE_EXIST=usr/share/file_999")
