self.description = "Scriptlet test (pre/post remove)"

p1 = pmpkg("dummy")
p1.files = ['etc/dummy.conf']
p1.install['pre_remove'] = "echo foobar > pre_remove"
p1.install['post_remove'] = "echo foobar > post_remove"
self.addpkg2db("local", p1)

self.args = "-R %s" % p1.name

self.addrule("PACMAN_RETCODE=0")
self.addrule("FILE_EXIST=pre_remove")
self.addrule("FILE_EXIST=post_remove")
