self.description = "Fileconflict file -> dir on package replacement (FS#24904)"

lp = pmpkg("dummy")
lp.files = ["dir/filepath",
            "dir/file"]
self.addpkg2db("local", lp)

p1 = pmpkg("replace")
p1.provides = ["dummy"]
p1.replaces = ["dummy"]
p1.files = ["dir/filepath/",
            "dir/filepath/file",
            "dir/file",
            "dir/file2"]
self.addpkg2db("sync", p1)

self.args = "-Su"

self.addrule("PACMAN_RETCODE=0")
self.addrule("!PKG_EXIST=dummy")
self.addrule("PKG_EXIST=replace")
