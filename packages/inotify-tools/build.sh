TERMUX_PKG_HOMEPAGE=https://github.com/rvoicilas/inotify-tools/wiki
TERMUX_PKG_DESCRIPTION="Programs providing a simple interface to inotify"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=3.20.2.2
TERMUX_PKG_SRCURL=https://github.com/rvoicilas/inotify-tools/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=770fb1d94ace659f975d7494e3ab8b421a6aab930b9c37c7c290ab5280abb7b8
TERMUX_PKG_BREAKS="inotify-tools-dev"
TERMUX_PKG_REPLACES="inotify-tools-dev"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	./autogen.sh
}

termux_step_make() {
	:
}

termux_step_make_install() {
	# the command-line tools needs the libinotifytools installed before building
	make -C libinotifytools install
	make install
}
