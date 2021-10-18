# coding=utf8
self.description = "Remove packages with evil filenames"

self.filesystem = ["usr/bin/endwithspace",
                   "spaces/name"]

p1 = pmpkg("spaces")
p1.files = ["usr/bin/endwithspace ",
            " spaces/name"]
self.addpkg2db("local", p1)

p2 = pmpkg("unicodechars")
# somewhat derived from FS#9906
p2.files = ["usr/share/Märchen",
            "usr/share/ƏƐƕƺ",
            "usr/share/предупреждение",
            "usr/share/סֶאבױ",
            "usr/share/←↯↻⇈",
            "usr/share/アヅヨヾ",
            "usr/share/错误"]
self.addpkg2db("local", p2)

self.args = "-R %s %s" % (p1.name, p2.name)

self.addrule("PACMAN_RETCODE=0")
self.addrule("!PKG_EXIST=%s" % p1.name)
self.addrule("!PKG_EXIST=%s" % p2.name)

for f in p1.files:
    self.addrule("!FILE_EXIST=%s" % f)
    self.addrule("FILE_EXIST=%s" % f.strip())
for f in p2.files:
    self.addrule("!FILE_EXIST=%s" % f)
