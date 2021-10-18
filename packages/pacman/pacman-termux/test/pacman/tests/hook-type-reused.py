self.description = "Hook using multiple 'Type's"

self.add_hook("hook",
        """
        [Trigger]
        Type = Package
        Type = Path
        Operation = Install
        Target = foo

        [Action]
        When = PostTransaction
        Exec = /bin/date
        """);

sp = pmpkg("foo")
self.addpkg2db("sync", sp)

self.args = "-S foo"

self.addrule("PACMAN_RETCODE=0")
self.addrule("PACMAN_OUTPUT=warning.*overwriting previous definition of Type")
