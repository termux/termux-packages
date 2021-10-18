self.description = "Hook with arguments"

self.add_hook("hook",
        """
        [Trigger]
        Type = Package
        Operation = Install
        Target = foo

        [Action]
        When = PreTransaction
        Exec = bin/sh -c ': > hook-output'
        """);

sp = pmpkg("foo")
self.addpkg2db("sync", sp)

self.args = "-S foo"

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_EXIST=foo")
self.addrule("FILE_EXIST=hook-output")
