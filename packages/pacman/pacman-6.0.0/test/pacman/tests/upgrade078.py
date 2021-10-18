self.description = "-U --recursive upgrades outdated dependencies"

# git (new package)
# |-- perl (up to date)
#     |-- glibc (out of date, will be updated)
# |-- curl (out of date, will be updated)
# |-- expat (up to date)

perl_lpkg = pmpkg("perl", "5.14.1-3")
perl_lpkg.depends = ["glibc"]
self.addpkg2db("local", perl_lpkg)

glibc_lpkg = pmpkg("glibc", "2.1.3-1")
self.addpkg2db("local", glibc_lpkg)

curl_lpkg = pmpkg("curl", "7.20-1")
self.addpkg2db("local", curl_lpkg)

expat_lpkg = pmpkg("expat", "2.0.1-6")
self.addpkg2db("local", expat_lpkg)

# Sync db
perl_sync = pmpkg("perl", "5.14.1-3")
perl_sync.depends = ["glibc"]
self.addpkg2db("sync", perl_sync)

glibc_sync = pmpkg("glibc", "2.1.4-4")
self.addpkg2db("sync", glibc_sync)

curl_sync = pmpkg("curl", "7.21.7-1")
self.addpkg2db("sync", curl_sync)

expat_sync = pmpkg("expat", "2.0.1-6")
self.addpkg2db("sync", expat_sync)

p = pmpkg("git", "1.7.6-1")
p.depends = ["curl", "expat", "perl"]

self.addpkg(p)
self.args = "-U --recursive %s" % p.filename()

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_DEPENDS=git|curl")
self.addrule("PKG_DEPENDS=git|expat")
self.addrule("PKG_DEPENDS=git|perl")
self.addrule("PKG_DEPENDS=perl|glibc")
self.addrule("PKG_EXIST=git")
self.addrule("PKG_VERSION=git|1.7.6-1")
self.addrule("PKG_VERSION=curl|7.21.7-1")
self.addrule("PKG_VERSION=glibc|2.1.4-4")
self.addrule("PKG_VERSION=perl|5.14.1-3")
self.addrule("PKG_VERSION=expat|2.0.1-6")

# --recursive operation was removed for now
self.expectfailure = True
