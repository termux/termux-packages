TERMUX_PKG_HOMEPAGE=https://www.stunnel.org/
TERMUX_PKG_DESCRIPTION="Socket wrapper which can provide TLS support to ordinary applications"
TERMUX_PKG_VERSION=5.42
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=1b6a7aea5ca223990bc8bd621fb0846baa4278e1b3e00ff6eee279cb8e540fab
TERMUX_PKG_SRCURL=https://www.stunnel.org/downloads/stunnel-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="openssl, libutil"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-shared --with-ssl=$TERMUX_PREFIX --disable-fips"
TERMUX_PKG_RM_AFTER_INSTALL="bin/stunnel3 share/man/man8/stunnel.*.8"

termux_step_pre_configure() {
	LDFLAGS+=" -llog"
}
