self.description = "Indirect dependency ordering (FS#32764)"

lp1 = pmpkg("fcitx-gtk2", "1.0-1");
lp1.depends = ["gtk2"]
self.addpkg2db("local", lp1)

lp2 = pmpkg("gtk2", "1.0-1");
lp2.depends = ["pango"]
self.addpkg2db("local", lp2)

lp3 = pmpkg("pango", "1.0-1");
lp3.depends = ["harfbuzz"]
self.addpkg2db("local", lp3)

lp4 = pmpkg("harfbuzz", "1.0-1");
lp4.depends = ["icu"]
self.addpkg2db("local", lp4)

lp5 = pmpkg("icu", "1.0-1");
self.addpkg2db("local", lp5)

sp1 = pmpkg("fcitx-gtk2", "1.0-2");
sp1.depends = ["gtk2"]
sp1.install['post_upgrade'] = "[ -f bin/harfbuzz ] && echo > found_harfbuzz"
self.addpkg2db("sync", sp1)

sp4 = pmpkg("harfbuzz", "1.0-2");
sp4.depends = ["icu"]
sp4.files = ["bin/harfbuzz"]
sp4.install['post_upgrade'] = "[ -f bin/icu ] && echo > found_icu"
self.addpkg2db("sync", sp4)

sp5 = pmpkg("icu", "1.0-2");
sp5.files = ["bin/icu"]
self.addpkg2db("sync", sp5)

self.args = "-Su"

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_VERSION=fcitx-gtk2|1.0-2")
self.addrule("PKG_VERSION=harfbuzz|1.0-2")
self.addrule("PKG_VERSION=icu|1.0-2")
self.addrule("FILE_EXIST=found_harfbuzz")
self.addrule("FILE_EXIST=found_icu")
