TERMUX_PKG_HOMEPAGE=https://www.fefe.de/gatling/
TERMUX_PKG_DESCRIPTION="A high performance http, ftp and smb server"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.16
TERMUX_PKG_SRCURL=https://www.fefe.de/gatling/gatling-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=5f96438ee201d7f1f6c2e0849ff273b196bdc7493f29a719ce8ed08c8be6365b
TERMUX_PKG_DEPENDS="libcrypt, libiconv, openssl, zlib"
TERMUX_PKG_BUILD_DEPENDS="libcap, libowfat"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="
prefix=$TERMUX_PREFIX
MANDIR=$TERMUX_PREFIX/share/man
"

termux_step_pre_configure() {
	CFLAGS+=" $CPPFLAGS"
	LDFLAGS+=" -lcrypt -lcrypto -liconv"
}
