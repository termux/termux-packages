self.description = "Scriptlet test (pre/post install)"

p1 = pmpkg("dummy")
p1.files = ['etc/dummy.conf']
p1.install['pre_install'] = "echo foobar > pre_install"
p1.install['post_install'] = "echo foobar > post_install"
self.addpkg(p1)

self.args = "-U %s" % p1.filename()

self.addrule("PACMAN_RETCODE=0")
self.addrule("FILE_EXIST=pre_install")
self.addrule("FILE_EXIST=post_install")
