self.description = "test deptest (-T) functionality"

lp1 = pmpkg("pkg1")
self.addpkg2db("local", lp1)

lp3 = pmpkg("pkg3", "2.0-1")
lp3.provides = ("prov=3.0")
self.addpkg2db("local", lp3)

self.args = "-T pkg1 pkg2 pkg3\>2.1 prov\>\=3.0"

self.addrule("PACMAN_RETCODE=127")
self.addrule("!PACMAN_OUTPUT=^pkg1")
self.addrule("PACMAN_OUTPUT=^pkg2")
self.addrule("PACMAN_OUTPUT=^pkg3")
self.addrule("!PACMAN_OUTPUT=^prov")
