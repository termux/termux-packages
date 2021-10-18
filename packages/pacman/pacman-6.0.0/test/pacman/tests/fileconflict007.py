self.description = "Fileconflict with symlinks (klibc case)"

lp = pmpkg("pkg")
lp.files = ["dir/realdir/",
            "dir/symdir -> realdir",
            "dir/realdir/file"]
self.addpkg2db("local", lp)

p = pmpkg("pkg", "1.0-2")
p.files = ["dir/symdir/file"]
self.addpkg(p)

self.args = "-U %s" % p.filename()

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_EXIST=pkg")
self.addrule("PKG_VERSION=pkg|1.0-2")
self.addrule("FILE_TYPE=dir/symdir/|dir")
