self.description = "Check the types of default files in a package"

p = pmpkg("pkg1")
p.files = ["foo/file1",
           "foo/file2",
           "foo/dir/",
           "foo/symdir -> dir"]
self.addpkg(p)

self.args = "-U %s" % p.filename()

self.addrule("PACMAN_RETCODE=0")
self.addrule("FILE_TYPE=foo/|dir")
self.addrule("FILE_TYPE=foo/file1|file")
self.addrule("FILE_TYPE=foo/file2|file")
self.addrule("FILE_TYPE=foo/dir|dir")
self.addrule("FILE_TYPE=foo/symdir|link")
