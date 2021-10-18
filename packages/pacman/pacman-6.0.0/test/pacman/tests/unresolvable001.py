self.description = "An unresolvable dependency"

packageA1 = pmpkg("dep")
self.addpkg2db("local", packageA1)

packageA1up = pmpkg("dep", "2.0-1")
packageA1up.depends = ["fake"];
self.addpkg2db("sync", packageA1up)

packageA2up = pmpkg("package")
packageA2up.depends = ["dep"];
self.addpkg2db("sync", packageA2up)

self.args = "-S package dep --ask=16"

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_EXIST=package")
self.addrule("PKG_EXIST=dep")
self.addrule("PKG_VERSION=dep|1.0-1")
