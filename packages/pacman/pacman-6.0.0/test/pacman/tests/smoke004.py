self.description = "Read a package DB with several PGP signatures"

for i in range(1000):
	sp = pmpkg("pkg%03d" % i)
	sp.desc = "test description for package %d" % i
	sp.pgpsig = "asdfasdfsdfasdfsdafasdfsdfasd"
	self.addpkg2db("sync", sp)

self.args = "-Ss"

self.addrule("PACMAN_RETCODE=0")
