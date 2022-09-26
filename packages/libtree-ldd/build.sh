TERMUX_PKG_HOMEPAGE=https://github.com/haampie/libtree
TERMUX_PKG_DESCRIPTION="Like ldd(1), but prints a tree(1) like output"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@flosnvjx"
TERMUX_PKG_VERSION=3.1.1
TERMUX_PKG_SRCURL=https://github.com/haampie/libtree/archive/refs/tags/v"$TERMUX_PKG_VERSION".tar.gz
TERMUX_PKG_SHA256=6148436f54296945d22420254dd78e1829d60124bb2f5b9881320a6550f73f5c
TERMUX_PKG_DEPENDS="libandroid-glob"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
	CFLAGS+=" $CPPFLAGS"
}
