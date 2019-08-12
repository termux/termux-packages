TERMUX_PKG_HOMEPAGE=https://dev.yorhel.nl/ncdc
TERMUX_PKG_DESCRIPTION="Modern and lightweight direct connect client with a friendly ncurses interface"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=1.22.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://dev.yorhel.nl/download/ncdc-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d15fd378aa345f423e59a38691c668f69b516cd4b8afbbcdc446007740c3afad
TERMUX_PKG_DEPENDS="libandroid-support, libiconv, libgnutls, libsqlite, bzip2, glib, ncurses, zlib"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_configure() {
	# Cross compiling steps documented in ncdc README
	gcc $TERMUX_PKG_SRCDIR/deps/makeheaders.c -o makeheaders
	gcc -I. $TERMUX_PKG_SRCDIR/doc/gendoc.c -o gendoc
	touch -d "next hour" makeheaders gendoc
}
