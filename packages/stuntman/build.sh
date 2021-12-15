TERMUX_PKG_HOMEPAGE=http://www.stunprotocol.org/
TERMUX_PKG_DESCRIPTION="An open source STUN server"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.2.16
TERMUX_PKG_SRCURL=http://www.stunprotocol.org/stunserver-${TERMUX_PKG_VERSION}.tgz
TERMUX_PKG_SHA256=4479e1ae070651dfc4836a998267c7ac2fba4f011abcfdca3b8ccd7736d4fd26
TERMUX_PKG_DEPENDS="libc++, openssl"
TERMUX_PKG_BUILD_DEPENDS="boost"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="T=" # In case if environment variable `T` is defined

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin "$TERMUX_PKG_BUILDDIR/stunclient"
	install -Dm700 -t $TERMUX_PREFIX/bin "$TERMUX_PKG_BUILDDIR/stunserver"
}
