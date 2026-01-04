TERMUX_PKG_HOMEPAGE=https://github.com/rvoicilas/inotify-tools/wiki
TERMUX_PKG_DESCRIPTION="Programs providing a simple interface to inotify"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.25.9.0"
TERMUX_PKG_SRCURL=https://github.com/rvoicilas/inotify-tools/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d33a4fd24c72c2d08893f129d724adf725b93dae96c359e4f4e9f32573cc853b
TERMUX_PKG_AUTO_UPDATE=true
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
