TERMUX_PKG_HOMEPAGE=https://github.com/rvoicilas/inotify-tools/wiki
TERMUX_PKG_DESCRIPTION="Programs providing a simple interface to inotify"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.26.272"
TERMUX_PKG_SRCURL="https://github.com/rvoicilas/inotify-tools/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=1572c72bf4113261aa0b148bddf5323e5d12b6f5a4b5ab4e1478a5d108f9e464
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_rust

	make \
		TARGET="${CARGO_TARGET_NAME}" \
		PROFILE=release
}

termux_step_make_install() {
	make install \
		TARGET="${CARGO_TARGET_NAME}" \
		PROFILE=release \
		DESTDIR="${TERMUX_PREFIX}" \
		prefix=/
}
