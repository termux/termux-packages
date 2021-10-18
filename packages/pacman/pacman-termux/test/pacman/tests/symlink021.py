self.description = "symlink -> dir replacment with file move"

lp1 = pmpkg("pkg1")
lp1.files = ["usr/include/foo/",
             "usr/include/bar -> foo",
             "usr/include/foo/header.h"]
self.addpkg2db("local", lp1)

sp1 = pmpkg("pkg1", "1.0-2")
sp1.files = ["usr/include/foo/",
             "usr/include/foo/header.h"]
self.addpkg2db("sync", sp1)

sp2 = pmpkg("pkg2", "1.0-2")
sp2.files = ["usr/include/bar/",
             "usr/include/bar/header.h"]
self.addpkg2db("sync", sp2)


self.args = "-S %s %s" % (sp1.name, sp2.name)

self.addrule("PACMAN_RETCODE=0")
self.addrule("FILE_TYPE=usr/include/foo|dir")
self.addrule("!FILE_TYPE=usr/include/bar|link")
self.addrule("FILE_EXIST=usr/include/foo/header.h")
self.addrule("FILE_EXIST=usr/include/bar/header.h")
