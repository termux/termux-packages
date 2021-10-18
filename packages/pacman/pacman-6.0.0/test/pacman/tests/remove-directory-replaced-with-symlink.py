self.description = "remove a package with a directory that has been replaced with a symlink"

self.filesystem = [ "var/", "srv -> var/" ]

lpkg = pmpkg("pkg1")
lpkg.files = ["srv/"]
self.addpkg2db("local", lpkg)

self.args = "-R %s" % (lpkg.name)

self.addrule("PACMAN_RETCODE=0")
self.addrule("DIR_EXIST=var/")
self.addrule("!LINK_EXIST=srv")
self.addrule("!FILE_EXIST=srv")
self.addrule("!DIR_EXIST=srv")
self.addrule("!PACMAN_OUTPUT=cannot remove")
