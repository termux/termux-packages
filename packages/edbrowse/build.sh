TERMUX_PKG_HOMEPAGE=https://edbrowse.org/
TERMUX_PKG_DESCRIPTION="Line based editor, browser, and mail client"
TERMUX_PKG_LICENSE="GPL-2.0-or-later, MIT, CC0-1.0, curl"
TERMUX_PKG_LICENSE_FILE="LICENSE, LICENSE.quickjs"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.8.12"
TERMUX_PKG_SRCURL=https://github.com/edbrowse/edbrowse/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b5125c7d13c2ed4491dc0d5a31116b244db62ae1c417ba5d29910311d1194632
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
