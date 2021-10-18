self.description = "Dummy test case (modify for own use)"

p1 = pmpkg("dummy")
p1.files = ["etc/dummy.conf*",
            "lib/libdummy.so.0",
            "lib/libdummy.so -> ./libdummy.so.0",
            "usr/",
            "bin/dummy"]
p1.backup = ["etc/dummy.conf*"]
p1.install['post_install'] = "echo toto";
p1.url="ze url"
self.addpkg(p1)

#p2 = pmpkg("dummy", "1.0-2")
#p2.files = ["etc/dummy.conf**"]
#p2.backup = ["etc/dummy.conf"]
#self.addpkg(p2)

self.args = "-U %s" % p1.filename()

self.addrule("PACMAN_RETCODE=0")
