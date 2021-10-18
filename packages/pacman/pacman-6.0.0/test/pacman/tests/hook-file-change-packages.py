self.description = "Triggering file moves between packages"

self.add_script("hook-script", ": > hook-output")
self.add_hook("hook",
        """
        [Trigger]
        Type = Path
        Operation = Upgrade
        Target = bin/foo

        [Action]
        When = PreTransaction
        Exec = bin/hook-script
        """);

lp = pmpkg("foo", "1-1")
lp.files = ["bin/foo"]
self.addpkg2db("local", lp)

sp1 = pmpkg("foo", "1-2")
self.addpkg2db("sync", sp1)

sp2 = pmpkg("bar", "1-2")
sp2.files = ["bin/foo"]
self.addpkg2db("sync", sp2)

self.args = "-S foo bar"

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_VERSION=foo|1-2")
self.addrule("PKG_VERSION=bar|1-2")
self.addrule("FILE_EXIST=hook-output")
