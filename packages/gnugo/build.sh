TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/gnugo/
TERMUX_PKG_DESCRIPTION="Program that plays the game of Go"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.8
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/gnugo/gnugo-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=da68d7a65f44dcf6ce6e4e630b6f6dd9897249d34425920bfdd4e07ff1866a72
TERMUX_PKG_DEPENDS="ncurses, readline"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-readline"
TERMUX_PKG_HOSTBUILD=true

termux_step_pre_configure() {
	CFLAGS+=" -Wno-overflow -fcommon"
}

termux_step_post_configure () {
	cp $TERMUX_PKG_HOSTBUILD_DIR/patterns/mkeyes $TERMUX_PKG_BUILDDIR/patterns/mkeyes
	cp $TERMUX_PKG_HOSTBUILD_DIR/patterns/uncompress_fuseki $TERMUX_PKG_BUILDDIR/patterns/uncompress_fuseki
	cp $TERMUX_PKG_HOSTBUILD_DIR/patterns/joseki $TERMUX_PKG_BUILDDIR/patterns/joseki
	cp $TERMUX_PKG_HOSTBUILD_DIR/patterns/mkmcpat $TERMUX_PKG_BUILDDIR/patterns/mkmcpat
	cp $TERMUX_PKG_HOSTBUILD_DIR/patterns/mkpat $TERMUX_PKG_BUILDDIR/patterns/mkpat
	touch -d "next hour" $TERMUX_PKG_BUILDDIR/patterns/*
}
