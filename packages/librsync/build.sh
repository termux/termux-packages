TERMUX_PKG_HOMEPAGE=https://github.com/librsync/librsync
TERMUX_PKG_DESCRIPTION="Remote delta-compression library"
TERMUX_PKG_VERSION=2.0.0
TERMUX_PKG_SRCURL=https://github.com/librsync/librsync/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b5c4dd114289832039397789e42d4ff0d1108ada89ce74f1999398593fae2169
TERMUX_PKG_FOLDERNAME=librsync-${TERMUX_PKG_VERSION}
TERMUX_PKG_DEPENDS="libbz2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DPERL_EXECUTABLE=`which perl`"

termux_step_pre_configure () {
	# Remove old files to ensure new timestamps on symlinks:
	rm -Rf $TERMUX_PREFIX/lib/librsync.*
}

termux_step_post_configure () {
	mkdir -p $TERMUX_PREFIX/share/man/man{1,3}
	cp $TERMUX_PKG_SRCDIR/doc/rdiff.1 $TERMUX_PREFIX/share/man/man1
	cp $TERMUX_PKG_SRCDIR/doc/librsync.3 $TERMUX_PREFIX/share/man/man3
}
