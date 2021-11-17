TERMUX_PKG_HOMEPAGE=https://github.com/librsync/librsync
TERMUX_PKG_DESCRIPTION="Remote delta-compression library"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.3.2
TERMUX_PKG_SRCURL=https://github.com/librsync/librsync/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ef8ce23df38d5076d25510baa2cabedffbe0af460d887d86c2413a1c2b0c676f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libbz2"
TERMUX_PKG_BUILD_DEPENDS="libpopt"
TERMUX_PKG_BREAKS="librsync-dev"
TERMUX_PKG_REPLACES="librsync-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DPERL_EXECUTABLE=$(which perl)"

termux_step_post_configure() {
	mkdir -p $TERMUX_PREFIX/share/man/man{1,3}
	cp $TERMUX_PKG_SRCDIR/doc/rdiff.1 $TERMUX_PREFIX/share/man/man1
	cp $TERMUX_PKG_SRCDIR/doc/librsync.3 $TERMUX_PREFIX/share/man/man3
}
