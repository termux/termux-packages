self.description = "Test invalid combination of command line options (-Qy)"

p = pmpkg("foobar")
self.addpkg2db("local", p)

self.args = "-Qy"

self.addrule("PACMAN_RETCODE=1")
