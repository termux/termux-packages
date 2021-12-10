TERMUX_PKG_HOMEPAGE=https://www.gcd.org/sengoku/stone/
TERMUX_PKG_DESCRIPTION="A TCP/IP repeater in the application layer"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.4
TERMUX_PKG_SRCURL=https://www.gcd.org/sengoku/stone/stone-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d5dc1af6ec5da503f2a40b3df3fe19a8fbf9d3ce696b8f46f4d53d2ac8d8eb6f
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="-e stone"

termux_step_configure() {
	CFLAGS+=" $CPPFLAGS"
	export FLAGS="-DUSE_SSL -DUNIX_DAEMON -DNO_RINDEX -DUSE_EPOLL -DPTHREAD -DPRCTL -UANDROID"
	export LIBS="$LDFLAGS -lssl -lcrypto"
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin stone
}
