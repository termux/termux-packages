TERMUX_PKG_HOMEPAGE=https://github.com/chaos/scrub
TERMUX_PKG_DESCRIPTION="Iteratively writes patterns on files or disk devices to make retreiving the data more difficult"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.6.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/chaos/scrub/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=838b061b2e1932b342fb9695c5579cdff5d2d72506cb41d6d8032eba18aed969

termux_step_pre_configure() {
	./autogen.sh
}
