self.description = "Check execute mode on files in a package"

p = pmpkg("pkg1")
p.files = ["bin/foo|755",
           "bin/bar|755"]
self.addpkg(p)

self.args = "-U %s" % p.filename()

self.addrule("PACMAN_RETCODE=0")
self.addrule("FILE_MODE=bin/foo|755")
self.addrule("FILE_MODE=bin/bar|755")
