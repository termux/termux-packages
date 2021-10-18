self.description = "Query info on a package (optdep install status [uninstalled])"

optstr = "dep: for foobar"

pkg = pmpkg("dummy", "1.0-2")
pkg.optdepends = [optstr]
self.addpkg2db("local", pkg)

self.args = "-Qi %s" % pkg.name

self.addrule("PACMAN_RETCODE=0")
self.addrule("PACMAN_OUTPUT=^Optional Deps.*%s$" % optstr)
