TERMUX_PKG_HOMEPAGE=https://edbrowse.org/
TERMUX_PKG_DESCRIPTION="Line based editor, browser, and mail client"
# License: GPL-2.0-or-later
TERMUX_PKG_LICENSE="GPL-2.0, MIT"
TERMUX_PKG_LICENSE_FILE="COPYING, LICENSE.quickjs"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.8.6
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/CMB/edbrowse/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=85ce43c2832e1e79ea24e23c7726757080ef966d7c2c387f8aa9be108f36bf26
TERMUX_PKG_DEPENDS="libandroid-glob, libcurl, openssl, pcre2, readline, unixodbc"
TERMUX_PKG_BUILD_DEPENDS="quickjs"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="-C src
PREFIX=$TERMUX_PREFIX
QUICKJS_DIR=$TERMUX_PREFIX/include/quickjs
"

termux_step_post_get_source() {
	cp $TERMUX_PKG_BUILDER_DIR/LICENSE.quickjs ./
}
