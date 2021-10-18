self.description = "dependency ranges should be satisfied by the same package"

lp1 = pmpkg("pkg1")
lp1.provides = ["dependency=2"]
self.addpkg2db("local", lp1)

lp2 = pmpkg("pkg2")
lp2.provides = ["dependency=5"]
self.addpkg2db("local", lp2)

p = pmpkg("pkg3")
p.depends = ["dependency>=3", "dependency<=4"]
self.addpkg(p)

self.args = "-U %s" % p.filename()
self.addrule("PACMAN_RETCODE=1")
self.addrule("!PKG_EXIST=pkg3")

self.expectfailure = True