self.description = "Sysupgrade with a replace on a provider"

sp1 = pmpkg("util-linux", "2.19.1-2")
sp1.provides = ["util-linux-ng=2.19.1"]
sp1.conflicts = ["util-linux-ng"]
sp1.replaces = ["util-linux-ng"]
self.addpkg2db("sync", sp1)

sp2 = pmpkg("util-linux-git", "20110811-1")
sp2.replaces = ["util-linux-ng"]
sp2.conflicts = ["util-linux-ng", "util-linux"]
sp2.provides = ["util-linux", "util-linux-ng"]
self.addpkg2db("local", sp2)

self.args = "-Su"

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_EXIST=util-linux-git")
self.addrule("!PKG_EXIST=util-linux")
