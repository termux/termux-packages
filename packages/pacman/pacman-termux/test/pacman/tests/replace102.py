self.description = "Sysupgrade with a versioned replacement, original stays"

sp1 = pmpkg("python2-yaml", "5-1")
sp1.replaces = ["python-yaml<5"]
sp1.conflicts = ["python-yaml<5"]
sp1.files = ["lib/python2/file"]
self.addpkg2db("sync", sp1)

# the python3 version
sp2 = pmpkg("python-yaml", "5-1")
sp2.files = ["lib/python3/file"]
self.addpkg2db("sync", sp2)

lp1 = pmpkg("python-yaml", "4-1")
lp1.files = ["lib/python2/file"]
self.addpkg2db("local", lp1)

self.args = "-Su"

self.addrule("PACMAN_RETCODE=0")
self.addrule("!PKG_EXIST=python-yaml")
self.addrule("PKG_VERSION=python2-yaml|5-1")
self.addrule("FILE_EXIST=lib/python2/file")
