self.description = "transferred file with glob characters that match a removed file"

lp = pmpkg("foo")
lp.files = ["foo/b*r", "foo/bar"]
self.addpkg2db("local", lp)

sp1 = pmpkg("foo", "1.0-2")
self.addpkg(sp1)

sp2 = pmpkg("bar", "1.0-2")
sp2.files = ["foo/b*r"]
self.addpkg(sp2)

self.args = "-U %s %s" % (sp1.filename(), sp2.filename())

self.addrule("PKG_VERSION=foo|1.0-2")
self.addrule("PKG_VERSION=bar|1.0-2")
self.addrule("FILE_EXIST=foo/b*r")
self.addrule("!FILE_EXIST=foo/bar")
