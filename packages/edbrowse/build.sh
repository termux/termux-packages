TERMUX_PKG_HOMEPAGE=https://edbrowse.org/
TERMUX_PKG_DESCRIPTION="Line based editor, browser, and mail client"
TERMUX_PKG_LICENSE="GPL-3.0-or-later, MIT, MPL-2.0"
TERMUX_PKG_LICENSE_FILE="../COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.8.0
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://github.com/CMB/edbrowse/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5d512b63ee69e418e5946557ebc703c19e6dccc515f358649a2d38063a6d6a69
TERMUX_PKG_DEPENDS="libandroid-glob, libcurl, pcre2, readline, tidy"
TERMUX_PKG_BUILD_DEPENDS="quickjs"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR="$TERMUX_PKG_SRCDIR/src"
}

termux_step_make_install() {
	install -Dm755 -t ${TERMUX_PREFIX}/bin src/edbrowse
}
