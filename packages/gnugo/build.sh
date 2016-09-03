TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/gnugo/
TERMUX_PKG_DESCRIPTION="Program that plays the game of Go"
TERMUX_PKG_VERSION=3.8
TERMUX_PKG_SRCURL=http://ftp.gnu.org/gnu/gnugo/gnugo-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="ncurses, readline"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-readline"
TERMUX_PKG_HOSTBUILD=yes

termux_step_pre_configure() {
	CFLAGS+=" -Wno-overflow"
}

termux_step_post_configure () {
	cp $TERMUX_PKG_HOSTBUILD_DIR/patterns/mkeyes $TERMUX_PKG_BUILDDIR/patterns/mkeyes
	cp $TERMUX_PKG_HOSTBUILD_DIR/patterns/uncompress_fuseki $TERMUX_PKG_BUILDDIR/patterns/uncompress_fuseki
	cp $TERMUX_PKG_HOSTBUILD_DIR/patterns/joseki $TERMUX_PKG_BUILDDIR/patterns/joseki
	cp $TERMUX_PKG_HOSTBUILD_DIR/patterns/mkmcpat $TERMUX_PKG_BUILDDIR/patterns/mkmcpat
	cp $TERMUX_PKG_HOSTBUILD_DIR/patterns/mkpat $TERMUX_PKG_BUILDDIR/patterns/mkpat
	$TERMUX_TOUCH -d "next hour" $TERMUX_PKG_BUILDDIR/patterns/*
}
