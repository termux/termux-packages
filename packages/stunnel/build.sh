TERMUX_PKG_HOMEPAGE=https://www.stunnel.org/
TERMUX_PKG_DESCRIPTION="Socket wrapper which can provide TLS support to ordinary applications"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=5.55
TERMUX_PKG_SRCURL=https://www.stunnel.org/downloads/stunnel-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=90de69f41c58342549e74c82503555a6426961b29af3ed92f878192727074c62
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-shared --with-ssl=$TERMUX_PREFIX --disable-fips"
TERMUX_PKG_RM_AFTER_INSTALL="bin/stunnel3 share/man/man8/stunnel.*.8"

termux_step_pre_configure() {
	LDFLAGS+=" -llog"
}
