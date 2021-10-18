self.description = "Add and remove separate files that match an upgrade hook"

self.add_script("hook-script", ": > hook-output")
self.add_hook("hook",
        """
        [Trigger]
        Type = Path
        Operation = Upgrade
        Target = bin/?*

        [Action]
        When = PreTransaction
        Exec = bin/hook-script
        """);

lp = pmpkg("foo")
lp.files = ["bin/foo"]
self.addpkg2db("local", lp)

sp = pmpkg("foo")
sp.files = ["bin/bar"]
self.addpkg2db("sync", sp)

self.args = "-S foo"

self.addrule("PACMAN_RETCODE=0")
self.addrule("!FILE_EXIST=hook-output")
