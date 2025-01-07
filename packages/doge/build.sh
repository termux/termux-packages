TERMUX_PKG_HOMEPAGE=https://github.com/Dj-Codeman/doge
TERMUX_PKG_DESCRIPTION="A command-line DNS client"
TERMUX_PKG_LICENSE="EUPL-1.2"
TERMUX_PKG_LICENSE_FILE="LICENCE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.2.7
TERMUX_PKG_SRCURL=https://github.com/Dj-Codeman/doge/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=7049e2ccd6907f4f4222b8ea84160d65b57aadbbee9498da353a00c576bc647e
TERMUX_PKG_REPLACES="dog"
TERMUX_PKG_DEPENDS="openssl, resolv-conf"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	rm $TERMUX_PKG_SRCDIR/makefile
}
