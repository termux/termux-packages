TERMUX_PKG_HOMEPAGE=https://edbrowse.org/
TERMUX_PKG_DESCRIPTION="Line based editor, browser, and mail client"
# License: GPL-2.0-or-later
TERMUX_PKG_LICENSE="GPL-2.0, MIT"
TERMUX_PKG_LICENSE_FILE="COPYING, LICENSE.quickjs"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.8.7
TERMUX_PKG_SRCURL=https://github.com/CMB/edbrowse/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2c7f6a07e5897060527b6cc5c19c45106444e2c4d8c9799434973c352d9ce4e6
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
