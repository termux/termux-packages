self.description = "Quick check for Include being parsed in [db]"

sp = pmpkg("dummy")
sp.files = ["bin/dummy",
            "usr/man/man1/dummy.1"]
self.addpkg2db("sync", sp)

self.db['sync'].option['Include'] = ['/dev/null']

self.args = "-Si %s" % sp.name

self.addrule("PACMAN_RETCODE=0")
