self.description = "Install a sync package with interdependent conflicts"

sp = pmpkg("pkg1")
sp.conflicts = ["pkg2", "pkg3", "pkg4"]
self.addpkg2db("sync", sp);

lp1 = pmpkg("pkg2")
lp1.depends = ["pkg3"]
lp1.install['pre_remove'] = "[ -f pkg3file ] && echo '' > pkg2ok"
self.addpkg2db("local", lp1);

lp2 = pmpkg("pkg3")
lp2.files = ["pkg3file"]
self.addpkg2db("local", lp2);

lp3 = pmpkg("pkg4")
lp3.depends = ["pkg3"]
lp3.install['pre_remove'] = "[ -f pkg3file ] && echo '' > pkg4ok"
self.addpkg2db("local", lp3);

self.args = "-S %s --ask=4" % sp.name

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_EXIST=pkg1")
self.addrule("!PKG_EXIST=pkg2")
self.addrule("!PKG_EXIST=pkg3")
self.addrule("!PKG_EXIST=pkg4")
self.addrule("FILE_EXIST=pkg2ok")
self.addrule("FILE_EXIST=pkg4ok")
