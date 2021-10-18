self.description = "install with recursive/cascading deps"

sp = pmpkg("pacman", "4.0.1-2")
sp.depends = ["glibc>=2.15", "curl"]
self.addpkg2db("sync", sp)

glibcdep = pmpkg("glibc", "2.15-1")
self.addpkg2db("sync", glibcdep)

gcldep = pmpkg("gcc-libs", "4.6.2-5")
gcldep.depends = ["glibc>=2.14"]
self.addpkg2db("sync", gcldep)

curldep = pmpkg("curl", "7.23.1-2")
curldep.depends = ["openssl"]
self.addpkg2db("sync", curldep)

openssldep = pmpkg("openssl", "1.0.0.e-1")
openssldep.depends = ["perl"]
self.addpkg2db("sync", openssldep)

gccdep = pmpkg("gcc", "4.6.2-5")
gccdep.depends = ["gcc-libs=4.6.2-5"]
self.addpkg2db("sync", gccdep)

perldep = pmpkg("perl", "5.14.2-5")
perldep.depends = ["db"]
self.addpkg2db("sync", perldep)

dbdep = pmpkg("db", "5.2.36-2")
dbdep.depends = ["gcc-libs"]
self.addpkg2db("sync", dbdep)


lp = pmpkg("pacman", "4.0.1-1")
lp.depends = ["glibc>=2.14", "curl"]
self.addpkg2db("local", lp)

lp2 = pmpkg("glibc", "2.14-2")
self.addpkg2db("local", lp2)

lp3 = pmpkg("curl", "7.23.1-2")
self.addpkg2db("local", lp3)

lp4 = pmpkg("gcc-libs", "4.6.2-3")
self.addpkg2db("local", lp4)

lp5 = pmpkg("gcc", "4.6.2-3")
lp5.depends = ["gcc-libs=4.6.2-3"]
self.addpkg2db("local", lp5)

lp6 = pmpkg("perl", "5.14.2-5")
lp6.depends = ["db"]
self.addpkg2db("local", lp6)

lp7 = pmpkg("db", "5.2.36-2")
lp7.depends = ["gcc-libs"]
self.addpkg2db("local", lp7)

self.args = "-S pacman"
self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_VERSION=pacman|4.0.1-2")
