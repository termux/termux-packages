self.description = "Query--check mtree, no mtree"

pkg = pmpkg("dummy")
pkg.files = [
    "usr/lib/libdummy.so.0",
    "usr/lib/libdummy.so -> libdummy.so.0",
    "usr/share/dummy/C/",
    "usr/share/dummy/C/msgs",
    "usr/share/dummy/en -> C"]
self.addpkg2db("local",pkg)

self.args = "-Qkk"

self.addrule("PACMAN_RETCODE=0")
self.addrule("PACMAN_OUTPUT=dummy: no mtree file")
