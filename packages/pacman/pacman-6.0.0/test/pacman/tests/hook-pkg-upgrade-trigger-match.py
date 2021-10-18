self.description = "Upgrade a package matching an Upgrade hook"

self.add_script("hook-script", ": > hook-output")
self.add_hook("hook",
        """
        [Trigger]
        Type = Package
        Operation = Upgrade
        Target = foo

        [Action]
        When = PreTransaction
        Exec = bin/hook-script
        """);

lp = pmpkg("foo", "1-1")
self.addpkg2db("local", lp)

sp = pmpkg("foo", "1-2")
self.addpkg2db("sync", sp)

self.args = "-S foo"

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_VERSION=foo|1-2")
self.addrule("FILE_EXIST=hook-output")
