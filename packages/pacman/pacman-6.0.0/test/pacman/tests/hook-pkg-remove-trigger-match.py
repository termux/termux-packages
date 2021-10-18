self.description = "Remove a package matching a removal hook"

self.add_script("hook-script", ": > hook-output")
self.add_hook("hook",
        """
        [Trigger]
        Type = Package
        Operation = Remove
        Target = foo

        [Action]
        When = PreTransaction
        Exec = bin/hook-script
        """);

lp = pmpkg("foo")
self.addpkg2db("local", lp)

self.args = "-R foo"

self.addrule("PACMAN_RETCODE=0")
self.addrule("!PKG_EXIST=foo")
self.addrule("FILE_EXIST=hook-output")
