import util
import os.path

self.description = "Install a package with dbonly"

sp = pmpkg("foobar", "1-1")
sp.files = ["bin/foobar"]
sp.install['post_install'] = "echo foobar"
self.addpkg2db("sync", sp)

self.args = "-S --dbonly %s" % sp.name

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_EXIST=foobar")
self.addrule("FILE_EXIST=%s" % os.path.join(util.PM_DBPATH, "local/foobar-1-1/install"))
self.addrule("!FILE_EXIST=bin/foobar")
