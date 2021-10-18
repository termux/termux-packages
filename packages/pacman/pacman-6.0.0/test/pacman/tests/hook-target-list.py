self.description = "Hook with NeedsTargets"

self.add_hook("hook",
        """
        [Trigger]
        Type = Package
        Operation = Install
        Target = foo

        # duplicate trigger to check that duplicate targets are removed
        [Trigger]
        Type = Package
        Operation = Install
        Target = foo

        [Trigger]
        Type = Path
        Operation = Install
        # matches files in 'file/' but not 'file/' itself
        Target = file/?*

        [Action]
        When = PreTransaction
        Exec = bin/sh -c 'while read -r tgt; do printf "%s\\n" "$tgt"; done > var/log/hook-output'
        NeedsTargets
        """);

p1 = pmpkg("foo")
p1.files = ["file/foo"]
self.addpkg(p1)

p2 = pmpkg("bar")
p2.files = ["file/bar"]
self.addpkg(p2)

self.args = "-U %s %s" % (p1.filename(), p2.filename())

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_EXIST=foo")
self.addrule("FILE_CONTENTS=var/log/hook-output|file/bar\nfile/foo\nfoo\n")
