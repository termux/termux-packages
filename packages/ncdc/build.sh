TERMUX_PKG_HOMEPAGE=http://dev.yorhel.nl/ncdc
TERMUX_PKG_DESCRIPTION="Modern and lightweight direct connect client with a friendly ncurses interface"
TERMUX_PKG_VERSION=1.19.1
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=http://dev.yorhel.nl/download/ncdc-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libandroid-support, libgnutls, libsqlite, bzip2, glib, ncurses"
TERMUX_PKG_BUILD_IN_SRC="yes"

termux_step_post_configure () {
	# Cross compiling steps documented in ncdc README
	gcc $TERMUX_PKG_SRCDIR/deps/makeheaders.c -o makeheaders
	gcc -I. $TERMUX_PKG_SRCDIR/doc/gendoc.c -o gendoc
	$TERMUX_TOUCH -d "next hour" makeheaders gendoc
}
