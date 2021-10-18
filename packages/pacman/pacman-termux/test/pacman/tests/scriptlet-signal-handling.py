self.description = "Handle signal interrupts while running scriptlets/hooks"

p1 = pmpkg("dummy")
p1.install['post_install'] = """
	kill -INT $PPID  # send an arbitrary signal that pacman catches
	sleep 1          # give alpm time to close the socket if EINTR was not handled
	echo to-parent   # if the interrupt is not handled this will die with SIGPIPE
	echo success > interrupt_was_handled
	"""
self.addpkg(p1)

self.args = "-U %s" % p1.filename()

self.addrule("PACMAN_RETCODE=0")
self.addrule("FILE_EXIST=interrupt_was_handled")
