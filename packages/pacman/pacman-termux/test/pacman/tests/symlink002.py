self.description = "Dead backed-up symlink when removing package (FS#24230)"

# symlink file is changed
lp = pmpkg("dummy")
lp.files = ["etc/brokenlink -> nonexistent",
            "etc/exists"]
lp.backup = ["etc/brokenlink*"]
self.addpkg2db("local", lp)

# symlink file is not changed
lp2 = pmpkg("dummy2")
lp2.files = ["etc/brokenlink2 -> nonexistent2",
            "etc/exists2"]
lp2.backup = ["etc/brokenlink2"]
self.addpkg2db("local", lp2)

# package is left alone, not uninstalled
lp3 = pmpkg("dummy3")
lp3.files = ["etc/brokenlink3 -> nonexistent3",
            "etc/exists3"]
self.addpkg2db("local", lp3)

self.args = "-R %s %s" % (lp.name, lp2.name)
#self.args = "-R"

self.addrule("PACMAN_RETCODE=0")

self.addrule("!PKG_EXIST=dummy")
self.addrule("!LINK_EXIST=etc/brokenlink")
self.addrule("!FILE_EXIST=etc/nonexistent")
self.addrule("!FILE_EXIST=etc/exists")

self.addrule("!PKG_EXIST=dummy2")
self.addrule("!LINK_EXIST=etc/brokenlink2")
self.addrule("!FILE_EXIST=etc/nonexistent2")
self.addrule("!FILE_EXIST=etc/exists2")

self.addrule("PKG_EXIST=dummy3")
self.addrule("LINK_EXIST=etc/brokenlink3")
self.addrule("!FILE_EXIST=etc/nonexistent3")
self.addrule("FILE_EXIST=etc/exists3")
self.addrule("FILE_TYPE=etc/brokenlink3|link")
self.addrule("FILE_TYPE=etc/exists3|file")
