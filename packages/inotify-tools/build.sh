TERMUX_PKG_HOMEPAGE=https://github.com/rvoicilas/inotify-tools/wiki
TERMUX_PKG_DESCRIPTION="Programs providing a simple interface to inotify"
TERMUX_PKG_VERSION=3.14
TERMUX_PKG_SRCURL=https://github.com/downloads/rvoicilas/inotify-tools/inotify-tools-${TERMUX_PKG_VERSION}.tar.gz

LDFLAGS+=" -llog"

termux_step_make () {
	continue
}

termux_step_make_install () {
	# the command-line tools needs the libinotifytools installed before building
	make -C libinotifytools install
	make install
}
