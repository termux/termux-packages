self.description = "Sync with relevant ignored packages"

package1 = pmpkg("package1")
self.addpkg2db("local", package1)

package2 = pmpkg("package2")
self.addpkg2db("local", package2)

package3 = pmpkg("package3")
package3.depends = ["package2=1.0-1"]
self.addpkg2db("local", package3)

package4 = pmpkg("package4")
package4.depends = ["package3=1.0-1"]
self.addpkg2db("local", package4)

package2up = pmpkg("package2", "2.0-1")
self.addpkg2db("sync", package2up)

package3up = pmpkg("package3", "2.0-1")
package3up.depends = ["package2=2.0-1"]
self.addpkg2db("sync", package3up)

package4up = pmpkg("package4", "2.0-1")
package4up.depends = ["package3=2.0-1"]
self.addpkg2db("sync", package4up)

self.option["IgnorePkg"] = ["package2"]
self.args = "-Su"

self.addrule("PACMAN_RETCODE=1")
self.addrule("PKG_VERSION=package1|1.0-1")
self.addrule("PKG_VERSION=package2|1.0-1")
self.addrule("PKG_VERSION=package3|1.0-1")
self.addrule("PKG_VERSION=package4|1.0-1")
