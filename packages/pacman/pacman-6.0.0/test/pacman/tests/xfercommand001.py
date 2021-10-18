self.description = "Quick check for using XferCommand"

# this setting forces us to download packages
self.cachepkgs = False
#wget doesn't support file:// urls.  curl does
self.option['XferCommand'] = ['/usr/bin/curl %u -o %o']

numpkgs = 10
pkgnames = []
for i in range(numpkgs):
    name = "pkg_%s" % i
    pkgnames.append(name)
    p = pmpkg(name)
    p.files = ["usr/bin/foo-%s" % i]
    self.addpkg2db("sync", p)

self.args = "-S %s" % ' '.join(pkgnames)

for name in pkgnames:
    self.addrule("PKG_EXIST=%s" % name)
