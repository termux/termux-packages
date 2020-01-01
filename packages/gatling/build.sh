TERMUX_PKG_HOMEPAGE=http://www.fefe.de/gatling/
TERMUX_PKG_DESCRIPTION="A high performance http, ftp and smb server"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=0.13
TERMUX_PKG_SRCURL=http://dl.fefe.de/gatling-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=b42145fdf7b66602fa8bc64661c2762172f6d33dbd9d53efebf821cd81e89245
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
