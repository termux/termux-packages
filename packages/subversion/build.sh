TERMUX_PKG_HOMEPAGE=https://subversion.apache.org
TERMUX_PKG_DESCRIPTION="Centralized version control system characterized by its simplicity"
TERMUX_PKG_VERSION=1.11.0
TERMUX_PKG_SHA256=87c44344b074ac2e9ed7ca9675fb1e5b197051c3deecfe5934e5f6aefbf83e56
TERMUX_PKG_SRCURL=https://www.apache.org/dist/subversion/subversion-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_DEPENDS="apr, apr-util, serf, libexpat, libsqlite, liblz4, utf8proc"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-sasl --without-libmagic"

termux_step_pre_configure() {
	CFLAGS+=" -std=c11"
}
