self.description = "Sync with ignore causing top-level to be ignored"

packageA1 = pmpkg("packageA1")
packageA1.depends = ["packageA2=1.0-1", "packageA3=1.0-1"];
self.addpkg2db("local", packageA1)

packageA2 = pmpkg("packageA2")
packageA2.depends = ["packageA4=1.0-1", "packageA5=1.0-1"];
self.addpkg2db("local", packageA2)

packageA3 = pmpkg("packageA3")
self.addpkg2db("local", packageA3)

packageA4 = pmpkg("packageA4")
self.addpkg2db("local", packageA4)

packageA5 = pmpkg("packageA5")
self.addpkg2db("local", packageA5)

packageA1up = pmpkg("packageA1", "2.0-1")
packageA1up.depends = ["packageA2=2.0-1", "packageA3=2.0-1"];
self.addpkg2db("sync", packageA1up)

packageA2up = pmpkg("packageA2", "2.0-1")
packageA2up.depends = ["packageA4=2.0-1", "packageA5=2.0-1"];
self.addpkg2db("sync", packageA2up)

packageA3up = pmpkg("packageA3", "2.0-1")
self.addpkg2db("sync", packageA3up)

packageA4up = pmpkg("packageA4", "2.0-1")
self.addpkg2db("sync", packageA4up)

packageA5up = pmpkg("packageA5", "2.0-1")
self.addpkg2db("sync", packageA5up)


self.option["IgnorePkg"] = ["packageA3"]
self.args = "-S packageA1"

self.addrule("PACMAN_RETCODE=1")
self.addrule("PKG_VERSION=packageA1|1.0-1")
self.addrule("PKG_VERSION=packageA2|1.0-1")
self.addrule("PKG_VERSION=packageA3|1.0-1")
self.addrule("PKG_VERSION=packageA4|1.0-1")
self.addrule("PKG_VERSION=packageA5|1.0-1")
