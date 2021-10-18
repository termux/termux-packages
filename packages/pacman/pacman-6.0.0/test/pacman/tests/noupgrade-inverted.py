self.description = "Upgrade a package with files that match negated NoUpgrade patterns"

lp = pmpkg("foobar")
lp.files = ["foo/bar", "foo/baz"]
self.addpkg2db("local", lp)

p = pmpkg("foobar", "1.0-2")
p.files = ["foo/bar"]
self.addpkg(p)

self.option["NoUpgrade"] = ["foo/*", "!foo/bar", "!foo/baz"]

self.args = "-U %s" % p.filename()

self.addrule("PKG_VERSION=foobar|1.0-2")
self.addrule("!FILE_EXIST=foo/baz")
self.addrule("FILE_MODIFIED=foo/bar")
self.addrule("!FILE_PACNEW=foo/bar")
self.addrule("!FILE_PACSAVE=foo/bar")
