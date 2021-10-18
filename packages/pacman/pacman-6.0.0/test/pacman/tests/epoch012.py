self.description = "usbutils case study: maintainer screws up and removes force"

sp = pmpkg("usbutils", "003-1")
self.addpkg2db("sync", sp)

lp = pmpkg("usbutils", "1:002-1")
self.addpkg2db("local", lp)

self.args = "-Su"

self.addrule("PACMAN_RETCODE=0")
# remember, this is how we have to handle this- 003 will not be installed
self.addrule("PKG_VERSION=usbutils|1:002-1")
