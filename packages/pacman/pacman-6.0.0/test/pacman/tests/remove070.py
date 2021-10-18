self.description = "Remove a package with various directory overlaps"

self.filesystem = ["lib/alsoonfs/randomfile"]

p1 = pmpkg("pkg1")
p1.files = ["bin/pkg1",
            "opt/",
            "lib/onlyinp1/",
            "lib/alsoonfs/"]

p2 = pmpkg("pkg2")
p2.files = ["bin/pkg2",
            "opt/",
            "lib/onlyinp2/"]

for p in p1, p2:
    self.addpkg2db("local", p)

self.args = "-R %s" % p1.name

self.addrule("PACMAN_RETCODE=0")
self.addrule("!PKG_EXIST=pkg1")
self.addrule("PKG_EXIST=pkg2")

self.addrule("DIR_EXIST=bin/")
self.addrule("DIR_EXIST=opt/")
self.addrule("!DIR_EXIST=lib/onlyinp1/")
self.addrule("DIR_EXIST=lib/onlyinp2/")
self.addrule("DIR_EXIST=lib/alsoonfs/")
