TERMUX_PKG_HOMEPAGE=https://edbrowse.org/
TERMUX_PKG_DESCRIPTION="Line based editor, browser, and mail client"
# License: GPL-2.0-or-later
TERMUX_PKG_LICENSE="GPL-2.0, MIT"
TERMUX_PKG_LICENSE_FILE="COPYING, LICENSE.quickjs"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.8.10"
TERMUX_PKG_SRCURL=https://github.com/CMB/edbrowse/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3c194ce45b7348211ce3ad8e3304a0eacf8b27e623cbf8c08687785f88174e03
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="libandroid-glob, libcurl, openssl, pcre2, readline, unixodbc"
TERMUX_PKG_BUILD_DEPENDS="quickjs"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="-C src
PREFIX=$TERMUX_PREFIX
QUICKJS_INCLUDE=$TERMUX_PREFIX/include/quickjs
QUICKJS_LIB=$TERMUX_PREFIX/lib/quickjs
"

termux_step_post_get_source() {
	cp $TERMUX_PKG_BUILDER_DIR/LICENSE.quickjs ./
}

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}
