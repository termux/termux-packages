self.description = "Upgrade a package with a filesystem conflict"

p = pmpkg("dummy", "2.0-1")
p.files = ["bin/dummy", "usr/share/file"]
self.addpkg(p)

lp = pmpkg("dummy", "1.0-1")
lp.files = ["bin/dummy"]
self.addpkg2db("local", lp)

self.filesystem = ["usr/share/file"]

self.args = "-U %s" % p.filename()

self.addrule("PACMAN_RETCODE=1")
self.addrule("PKG_VERSION=dummy|1.0-1")
