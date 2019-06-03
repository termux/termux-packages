TERMUX_PKG_HOMEPAGE=https://github.com/rvoicilas/inotify-tools/wiki
TERMUX_PKG_DESCRIPTION="Programs providing a simple interface to inotify"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=3.20.1
TERMUX_PKG_SHA256=a433cc1dedba851078276db69b0e97f9fe41e4ba3336d2971adfca4b3a6242ac
TERMUX_PKG_SRCURL=https://github.com/rvoicilas/inotify-tools/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
	./autogen.sh

	LDFLAGS+=" -llog"
}

termux_step_make() {
	:
}

termux_step_make_install() {
	# the command-line tools needs the libinotifytools installed before building
	make -C libinotifytools install
	make install
}
