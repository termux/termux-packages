self.description = "Install packages with huge descriptions"

p1 = pmpkg("pkg1")
p1.desc = 'A' * 500 * 1024
self.addpkg(p1)

p2 = pmpkg("pkg2")
p2.desc = 'A' * 600 * 1024
self.addpkg(p2)

self.args = "-U %s %s" % (p1.filename(), p2.filename())

# We error out when fed a package with an invalid description; the second one
# fits the bill in this case as the desc is > 512K
self.addrule("PACMAN_RETCODE=1")
self.addrule("!PKG_EXIST=pkg1")
self.addrule("!PKG_EXIST=pkg1")
