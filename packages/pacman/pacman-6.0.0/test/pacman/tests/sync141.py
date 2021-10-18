self.description = "Sysupgrade with ignored package prevent other upgrade"

lp1 = pmpkg("c_glibc", "1.0-1")
lp2 = pmpkg("b_gcc-libs", "1.0-1")
lp2.depends = ["c_glibc>=1.0-1"]
lp3 = pmpkg("a_pcre", "1.0-1")
lp3.depends = ["b_gcc-libs"]

for p in lp1, lp2, lp3:
	self.addpkg2db("local", p)

sp1 = pmpkg("c_glibc", "1.0-2")
sp2 = pmpkg("b_gcc-libs", "1.0-2")
sp2.depends = ["c_glibc>=1.0-2"]
sp3 = pmpkg("a_pcre", "1.0-2")
sp3.depends = ["b_gcc-libs"]

for p in sp1, sp2, sp3:
	self.addpkg2db("sync", p)

self.args = "-Su --ignore %s --ask=16" % sp1.name

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_VERSION=c_glibc|1.0-1")
self.addrule("PKG_VERSION=b_gcc-libs|1.0-1")
self.addrule("PKG_VERSION=a_pcre|1.0-2")
