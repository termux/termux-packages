self.description = "Add a bogus signature to a package DB"
self.require_capability("gpg")

sp = pmpkg("pkg1")
sp.pgpsig = "asdfasdfsdfasdfsdafasdfsdfasd"
self.addpkg2db("sync+Optional", sp)

self.args = "-Ss"

self.addrule("PACMAN_RETCODE=0")
