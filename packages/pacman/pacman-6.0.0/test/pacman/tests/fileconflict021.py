self.description = "upgrade package overwriting existing unowned file with directory"

lp1 = pmpkg("pkg1")
self.addpkg2db("local", lp1)

self.filesystem = ["file"]

p = pmpkg("pkg1", "1.0-2")
p.files = ["file/"]
self.addpkg2db("sync", p)

self.args = "-S pkg1"

self.addrule("PACMAN_RETCODE=1")
self.addrule("PKG_VERSION=pkg1|1.0-1")
self.addrule("!DIR_EXIST=file/")
