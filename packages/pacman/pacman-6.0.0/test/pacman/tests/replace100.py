self.description = "Sysupgrade with a replace and dependency chain"

sp1 = pmpkg("util-linux", "2.19-1")
sp1.replaces = ["util-linux-ng"]
sp1.conflicts = ["util-linux-ng"]
sp1.provides = ["util-linux-ng=2.19"]
sp1.files = ["sbin/blkid"]
self.addpkg2db("sync", sp1)

sp2 = pmpkg("mkinitcpio", "0.6.8-1")
sp2.depends = ["util-linux-ng>=2.17"]
self.addpkg2db("sync", sp2)

sp3 = pmpkg("kernel26", "2.6.37.1-1")
sp3.depends = ["mkinitcpio>=0.6.8"]
# /sbin/blkid is in both util-linux and util-linux-ng; however, if we cannot
# find it, that means we ended up in limbo between removing the old named
# package and installing the new named package.
sp3.install['post_upgrade'] = "if [ -f sbin/blkid ]; then echo '' > foundit; fi"
self.addpkg2db("sync", sp3)


lp1 = pmpkg("util-linux-ng", "2.18-1")
lp1.files = ["sbin/blkid"]
self.addpkg2db("local", lp1)

lp2 = pmpkg("mkinitcpio", "0.6.8-1")
lp2.depends = ["util-linux-ng>=2.17"]
self.addpkg2db("local", lp2)

lp3 = pmpkg("kernel26", "2.6.37-1")
lp3.depends = ["mkinitcpio>=0.6.8"]
self.addpkg2db("local", lp3)


self.args = "-Su"

self.addrule("PACMAN_RETCODE=0")
self.addrule("!PKG_EXIST=util-linux-ng")
self.addrule("PKG_VERSION=util-linux|2.19-1")
self.addrule("PKG_VERSION=kernel26|2.6.37.1-1")
self.addrule("FILE_EXIST=sbin/blkid")
self.addrule("FILE_EXIST=foundit")
