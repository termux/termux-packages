TERMUX_PKG_HOMEPAGE=https://github.com/cernekee/stoken
TERMUX_PKG_DESCRIPTION="RSA SecurID-compatible software token for Linux/UNIX systems"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.92
TERMUX_PKG_SRCURL=https://github.com/cernekee/stoken/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9b9c5e0f09ca14a54454319b64af98a02d0ae1b3eb1122c95e2130736f440cd1
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="libtomcrypt, libxml2"

termux_step_pre_configure() {
	cd $TERMUX_PKG_SRCDIR
	./autogen.sh
	./configure
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin $TERMUX_PKG_SRCDIR/stoken
}
