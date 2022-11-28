TERMUX_PKG_HOMEPAGE=https://dev.yorhel.nl/ncdc
TERMUX_PKG_DESCRIPTION="Modern and lightweight direct connect client with a friendly ncurses interface"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.23.1
TERMUX_PKG_SRCURL=https://dev.yorhel.nl/download/ncdc-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=95881214077a5b3c24fbbaf020ada0d084ee3b596a7c3cc1e0e68aaac4c9b5e6
TERMUX_PKG_DEPENDS="glib, libbz2, libgnutls, libsqlite, ncurses, zlib"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_configure() {
	# Cross compiling steps documented in ncdc README
	gcc $TERMUX_PKG_SRCDIR/deps/makeheaders.c -o makeheaders
	gcc -I. $TERMUX_PKG_SRCDIR/doc/gendoc.c -o gendoc
	touch -d "next hour" makeheaders gendoc
}
