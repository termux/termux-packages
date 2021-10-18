self.description = "Reset signals before running scriptlets/hooks"

p1 = pmpkg("dummy")
# check if SIGPIPE is ignored, it should be fatal, but GPGME ignores it
p1.install['post_install'] = "kill -PIPE $$; echo fail > sigpipe_was_ignored"
self.addpkg(p1)

self.args = "-U %s" % p1.filename()

self.addrule("PACMAN_RETCODE=0")
self.addrule("!FILE_EXIST=sigpipe_was_ignored")
