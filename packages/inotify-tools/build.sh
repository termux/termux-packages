TERMUX_PKG_HOMEPAGE=https://github.com/rvoicilas/inotify-tools/wiki
TERMUX_PKG_DESCRIPTION="Programs providing a simple interface to inotify"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.26.291"
TERMUX_PKG_SRCURL="https://github.com/rvoicilas/inotify-tools/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=46b1a5569772011b23f0059330bc46affa8aaaf0ed790edc28114d6c10e690eb
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
