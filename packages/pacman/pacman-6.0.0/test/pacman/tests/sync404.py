self.description = "FS#9024"

sp = pmpkg("xorg-server")
sp.depends = [ "libgl" ]
self.addpkg2db("sync", sp)

sp1 = pmpkg("nvidia-utils")
sp1.provides = [ "libgl" ]
sp1.conflicts = [ "libgl", "libgl-dri" ]
self.addpkg2db("sync", sp1)

sp2 = pmpkg("libgl")
sp2.provides = [ "libgl-dri" ]
self.addpkg2db("sync", sp2)

sp3 = pmpkg("nvidia")
sp3.depends = [ "nvidia-utils" ]
self.addpkg2db("sync", sp3)

self.args = "-S xorg-server nvidia"

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_EXIST=xorg-server")
self.addrule("PKG_EXIST=nvidia")
self.addrule("PKG_EXIST=nvidia-utils")
self.addrule("!PKG_EXIST=libgl")
