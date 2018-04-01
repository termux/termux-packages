TERMUX_PKG_HOMEPAGE=https://dev.yorhel.nl/ncdc
TERMUX_PKG_DESCRIPTION="Modern and lightweight direct connect client with a friendly ncurses interface"
TERMUX_PKG_VERSION=1.20
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://dev.yorhel.nl/download/ncdc-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8a998857df6289b6bd44287fc06f705b662098189f2a8fe95b1a5fbc703b9631
TERMUX_PKG_DEPENDS="libandroid-support, libgnutls, libsqlite, bzip2, glib, ncurses"
TERMUX_PKG_BUILD_DEPENDS="libbz2-dev, libnettle-dev, libidn-dev"
TERMUX_PKG_BUILD_IN_SRC="yes"

termux_step_post_configure () {
	# Cross compiling steps documented in ncdc README
	gcc $TERMUX_PKG_SRCDIR/deps/makeheaders.c -o makeheaders
	gcc -I. $TERMUX_PKG_SRCDIR/doc/gendoc.c -o gendoc
	touch -d "next hour" makeheaders gendoc
}
