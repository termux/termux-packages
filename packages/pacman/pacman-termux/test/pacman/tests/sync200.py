self.description = "Synchronize the local database"

self.option['XferCommand'] = ['/usr/bin/curl %u -o %o']

sp1 = pmpkg("spkg1", "1.0-1")
sp1.depends = ["spkg2"]
sp2 = pmpkg("spkg2", "2.0-1")
sp2.depends = ["spkg3"]
sp3 = pmpkg("spkg3", "3.0-1")
sp3.depends = ["spkg1"]

for sp in sp1, sp2, sp3:
	self.addpkg2db("sync", sp)

self.args = "-Sy"

self.addrule("PACMAN_RETCODE=0")
