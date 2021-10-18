self.description = "upgrade a package with a disabled repo"

sp = pmpkg("dummy", "2.0-1")
self.addpkg2db("syncdisabled", sp)

sp = pmpkg("dummy", "1.0-2")
self.addpkg2db("sync", sp)

lp = pmpkg("dummy", "1.0-1")
self.addpkg2db("local", lp)

self.args = "-S %s" % sp.name

self.db['syncdisabled'].option['Usage'] = ['Search']

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_VERSION=dummy|1.0-2")
