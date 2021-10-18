self.description = "phonon/qt issue"

sp1 = pmpkg("kdelibs")
sp1.depends = ["phonon"]
self.addpkg2db("sync", sp1);

sp2 = pmpkg("qt", "4.6.1-1")
self.addpkg2db("sync", sp2)

sp3 = pmpkg("phonon")
self.addpkg2db("sync", sp3)

lp = pmpkg("qt", "4.5.3-1")
lp.provides = ["phonon"]
lp.conflicts = ["phonon"]
self.addpkg2db("local", lp)

self.args = "-S %s" % " ".join([p.name for p in (sp1, sp2)])

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_EXIST=kdelibs")
self.addrule("PKG_EXIST=qt")
self.addrule("PKG_EXIST=phonon")
self.addrule("PKG_VERSION=qt|4.6.1-1")
