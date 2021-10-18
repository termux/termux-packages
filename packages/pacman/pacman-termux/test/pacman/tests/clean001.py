self.description = "CleanMethod = KeepInstalled"

sp = pmpkg("dummy", "2.0-1")
self.addpkg2db("sync", sp)

sp = pmpkg("bar", "2.0-1")
self.addpkg2db("sync", sp)

sp = pmpkg("baz", "2.0-1")
self.addpkg2db("sync", sp)

lp = pmpkg("dummy", "1.0-1")
self.addpkg2db("local", lp)

lp = pmpkg("bar", "2.0-1")
self.addpkg2db("local", lp)

self.args = "-Sc"
self.option['CleanMethod'] = ['KeepInstalled']
self.createlocalpkgs = True

self.addrule("PACMAN_RETCODE=0")
self.addrule("!CACHE_EXISTS=dummy|2.0-1")
self.addrule("CACHE_EXISTS=dummy|1.0-1")
self.addrule("CACHE_EXISTS=bar|2.0-1")
self.addrule("!CACHE_EXISTS=baz|2.0-1")
