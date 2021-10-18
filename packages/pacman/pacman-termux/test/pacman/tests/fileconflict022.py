self.description = "File conflict between package with symlink and package with real path"

self.filesystem = ["usr/lib/", "lib -> usr/lib/"]

sp1 = pmpkg("foo")
# share/ causes the entries to be reordered after path resolution
sp1.files = ["lib/", "lib/file", "share/"]
self.addpkg2db("sync", sp1)

sp2 = pmpkg("bar")
sp2.files = ["usr/", "usr/lib/", "usr/lib/file"]
self.addpkg2db("sync", sp2)

self.args = "-S %s %s" % (sp1.name, sp2.name)

self.addrule("PACMAN_RETCODE=1")
self.addrule("!PKG_EXIST=foo")
self.addrule("!PKG_EXIST=bar")
