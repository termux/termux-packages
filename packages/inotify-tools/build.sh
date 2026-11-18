TERMUX_PKG_HOMEPAGE=https://github.com/rvoicilas/inotify-tools/wiki
TERMUX_PKG_DESCRIPTION="Programs providing a simple interface to inotify"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.26.287"
TERMUX_PKG_SRCURL="https://github.com/rvoicilas/inotify-tools/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=d25b7229bccc915db55695a11c9d3a0c3aa6aa385c261297404fffa911e3fd68
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
