self.description = "Dir symlinks overwritten on install (the perl/git bug)"

lp = pmpkg("dummy")
lp.files = ["dir/realdir/",
            "dir/symdir -> realdir"]
self.addpkg2db("local", lp)

p = pmpkg("pkg1")
p.files = ["dir/symdir/tmp"]
self.addpkg(p)

self.args = "-U %s" % p.filename()

self.addrule("PACMAN_RETCODE=1")
self.addrule("!PKG_EXIST=pkg1")
self.addrule("!FILE_EXIST=dir/symdir/tmp")
self.addrule("!FILE_EXIST=dir/realdir/tmp")
self.addrule("FILE_TYPE=dir/symdir|link")
self.addrule("FILE_TYPE=dir/realdir|dir")
