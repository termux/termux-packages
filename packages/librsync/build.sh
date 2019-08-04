TERMUX_PKG_HOMEPAGE=https://github.com/librsync/librsync
TERMUX_PKG_DESCRIPTION="Remote delta-compression library"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_VERSION=2.0.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=e67b9520ee84f7239be6e948795803bd95495091cc00bf6d0e8c6976032a4af1
TERMUX_PKG_SRCURL=https://github.com/librsync/librsync/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libbz2"
TERMUX_PKG_BREAKS="librsync-dev"
TERMUX_PKG_REPLACES="librsync-dev"
TERMUX_PKG_BUILD_DEPENDS="libpopt"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DPERL_EXECUTABLE=$(which perl)"

termux_step_pre_configure() {
	# Remove old files to ensure new timestamps on symlinks:
	rm -Rf $TERMUX_PREFIX/lib/librsync.*
}

termux_step_post_configure() {
	mkdir -p $TERMUX_PREFIX/share/man/man{1,3}
	cp $TERMUX_PKG_SRCDIR/doc/rdiff.1 $TERMUX_PREFIX/share/man/man1
	cp $TERMUX_PKG_SRCDIR/doc/librsync.3 $TERMUX_PREFIX/share/man/man3
}
