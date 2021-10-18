self.description = "Sysupgrade with a set of sync packages replacing a set of local ones"

sp1 = pmpkg("pkg2")
sp1.replaces = ["pkg1"]

sp2 = pmpkg("pkg3")
sp2.replaces = ["pkg1"]

sp3 = pmpkg("pkg4")
sp3.replaces = ["pkg1", "pkg0"]

sp4 = pmpkg("pkg5")
sp4.replaces = ["pkg0"]

for p in sp1, sp2, sp3, sp4:
	self.addpkg2db("sync", p)

lp1 = pmpkg("pkg1")

lp2 = pmpkg("pkg0")

for p in lp1, lp2:
	self.addpkg2db("local", p)

self.args = "-Su"

self.addrule("PACMAN_RETCODE=0")
for p in lp1, lp2:
	self.addrule("!PKG_EXIST=%s" % p.name)
for p in sp1, sp2, sp3, sp4:
	self.addrule("PKG_EXIST=%s" % p.name)
