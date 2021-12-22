TERMUX_PKG_HOMEPAGE=https://www.fefe.de/gatling/
TERMUX_PKG_DESCRIPTION="A high performance http, ftp and smb server"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.15
TERMUX_PKG_SRCURL=https://www.fefe.de/gatling/gatling-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=6fa329d0ced0c80deb8dde5460e9d9e984bee94f265043d7fdec0e253dce9aa4
TERMUX_PKG_DEPENDS="libcrypt, libiconv, openssl, zlib"
TERMUX_PKG_BUILD_DEPENDS="libowfat"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	CPPFLAGS+=" -I$TERMUX_PREFIX/include/libowfat"
	LDFLAGS+=" -lcrypt -lcrypto -liconv"
	make -j $TERMUX_MAKE_PROCESSES CROSS="${CC/clang}"
}

termux_step_make_install() {
	make install prefix=$TERMUX_PREFIX MANDIR=$TERMUX_PREFIX/share/man
}
