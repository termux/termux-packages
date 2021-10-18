self.description = "Remove packages which is an optdepend of another package"

p1 = pmpkg("dep")
self.addpkg2db("local", p1)

p2 = pmpkg("pkg")
p2.optdepends = ["dep: for foobar"]
self.addpkg2db("local", p2)

self.args = "-R %s" % p1.name

self.addrule("PACMAN_RETCODE=0")
self.addrule("!PKG_EXIST=%s" % p1.name)
self.addrule("PKG_EXIST=%s" % p2.name)
self.addrule("PACMAN_OUTPUT=%s optionally requires %s" % (p2.name, p1.name))
