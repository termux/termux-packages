self.description = "Sync with irrelevant ignored packages"

package1 = pmpkg("package1")
self.addpkg2db("local", package1)

package2 = pmpkg("package2")
self.addpkg2db("local", package2)

package2up = pmpkg("package2", "2.0-1")
self.addpkg2db("sync", package2up)

self.option["IgnorePkg"] = ["irrelevant"]
self.args = "-Su"

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_VERSION=package1|1.0-1")
self.addrule("PKG_VERSION=package2|2.0-1")
