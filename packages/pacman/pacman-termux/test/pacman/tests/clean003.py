self.description = "CleanMethod = KeepInstalled with IgnorePkg (FS#22653)"

sp = pmpkg("dummy", "2.0-1")
self.addpkg2db("sync", sp)

lp = pmpkg("dummy", "1.0-1")
self.addpkg2db("local", lp)

self.args = "-Sc"
self.option['CleanMethod'] = ['KeepInstalled']
self.option['IgnorePkg'] = ['dummy']
self.createlocalpkgs = True

self.addrule("PACMAN_RETCODE=0")
self.addrule("!CACHE_EXISTS=dummy|2.0-1")
self.addrule("CACHE_EXISTS=dummy|1.0-1")
