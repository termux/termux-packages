self.description = "Remove a no longer needed package (multiple provision)"

lp1 = pmpkg("pkg1")
lp1.provides = ["imaginary"]
self.addpkg2db("local", lp1)

lp2 = pmpkg("pkg2")
lp2.provides = ["imaginary"]
self.addpkg2db("local", lp2)

lp3 = pmpkg("pkg3")
lp3.depends = ["imaginary"]
self.addpkg2db("local", lp3)

self.args = "-R %s" % lp1.name

self.addrule("PACMAN_RETCODE=0")
self.addrule("!PKG_EXIST=pkg1")
self.addrule("PKG_EXIST=pkg2")
