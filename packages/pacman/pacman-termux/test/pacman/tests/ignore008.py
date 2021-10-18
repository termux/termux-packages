self.description = "Sync with relevant ignored fnmatched packages"

package1 = pmpkg("foopkg", "1.0-1")
self.addpkg2db("local", package1)

package2 = pmpkg("barpkg", "2.0-1")
self.addpkg2db("local", package2)

package3 = pmpkg("bazpkg", "3.0-1")
self.addpkg2db("local", package3)


package1up = pmpkg("foopkg", "2.0-1")
self.addpkg2db("sync", package1up)

package2up = pmpkg("barpkg", "3.0-1")
self.addpkg2db("sync", package2up)

package3up = pmpkg("bazpkg", "4.0-1")
self.addpkg2db("sync", package3up)

self.option["IgnorePkg"] = ["foo*", "ba?pkg"]
self.args = "-Su"


self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_VERSION=foopkg|1.0-1")
self.addrule("PKG_VERSION=barpkg|2.0-1")
self.addrule("PKG_VERSION=bazpkg|3.0-1")
