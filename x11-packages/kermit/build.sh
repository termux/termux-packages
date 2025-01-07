TERMUX_PKG_HOMEPAGE=https://github.com/orhun/kermit
TERMUX_PKG_DESCRIPTION="A VTE-based simple and froggy terminal emulator"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.0"
TERMUX_PKG_SRCURL=https://github.com/orhun/kermit/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5ee5d7ed395b89a35678096ea7d3a7901714b9575f64813045fb3f6e7fc8c8a7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, gtk3, libvte, pango"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin ./kermit
}
