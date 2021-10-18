# coding=utf8
self.description = "Sync packages with evil filenames"

self.filesystem = ["usr/bin/endwithspace",
                   "usr/bin/newendwithspace",
                   "usr/bin/disappear",
                   "spaces/name",
                   "spaces/name2"]

p1 = pmpkg("spaces")
p1.files = ["usr/bin/endwithspace ",
            "usr/bin/disappear ",
            " spaces/name",
            " spaces/gone"]
self.addpkg2db("local", p1)

sp1 = pmpkg("spaces", "1.1-1")
sp1.files = ["usr/bin/endwithspace ",
             "usr/bin/newendwithspace ",
             " spaces/name",
             " spaces/name2"]
self.addpkg2db("sync", sp1)

names = ["Märchen", "ƏƐƕƺ", "предупреждение", "סֶאבױ",
         "←↯↻⇈", "アヅヨヾ", "错误"]

p2 = pmpkg("unicodechars")
# somewhat derived from FS#9906
p2.files = ["usr/share/%s" % name for name in names]
self.addpkg2db("local", p2)

sp2 = pmpkg("unicodechars", "2.0-1")
sp2.files = ["usr/man/%s" % name for name in names]
self.addpkg2db("sync", sp2)

self.args = "-S %s %s" % (sp1.name, sp2.name)

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_VERSION=%s|%s" % (sp1.name, sp1.version))
self.addrule("PKG_VERSION=%s|%s" % (sp2.name, sp2.version))

for f in self.filesystem:
    self.addrule("FILE_EXIST=%s" % f)
self.addrule("FILE_EXIST=usr/bin/endwithspace ")
self.addrule("FILE_EXIST= spaces/name")
self.addrule("FILE_EXIST= spaces/name2")
self.addrule("!FILE_EXIST=usr/bin/disappear ")
for f in p2.files:
    self.addrule("!FILE_EXIST=%s" % f)
for f in sp2.files:
    self.addrule("FILE_EXIST=%s" % f)
