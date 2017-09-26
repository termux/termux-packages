TERMUX_PKG_HOMEPAGE=https://github.com/rvoicilas/inotify-tools/wiki
TERMUX_PKG_DESCRIPTION="Programs providing a simple interface to inotify"
TERMUX_PKG_VERSION=3.14
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/downloads/rvoicilas/inotify-tools/inotify-tools-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=222bcca8893d7bf8a1ce207fb39ceead5233b5015623d099392e95197676c92f
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
	LDFLAGS+=" -llog"
}

termux_step_make () {
	continue
}

termux_step_make_install () {
	# the command-line tools needs the libinotifytools installed before building
	make -C libinotifytools install
	make install
}
