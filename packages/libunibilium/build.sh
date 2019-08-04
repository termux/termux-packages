TERMUX_PKG_HOMEPAGE=https://github.com/mauke/unibilium
TERMUX_PKG_DESCRIPTION="Terminfo parsing library"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_VERSION=2.0.0
TERMUX_PKG_REVISION=3
TERMUX_PKG_SHA256=78997d38d4c8177c60d3d0c1aa8c53fd0806eb21825b7b335b1768d7116bc1c1
TERMUX_PKG_BREAKS="libunibilium-dev"
TERMUX_PKG_REPLACES="libunibilium-dev"
TERMUX_PKG_SRCURL=https://github.com/mauke/unibilium/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_make() {
	return
}

termux_step_make_install() {
	CFLAGS+=" -DTERMINFO_DIRS=\"$TERMUX_PREFIX/share/terminfo/\""
	$CC $CFLAGS -c -fPIC unibilium.c -o unibilium.o
	$CC $CFLAGS -c -fPIC uninames.c -o uninames.o
	$CC $CFLAGS -c -fPIC uniutil.c -o uniutil.o
	$CC -shared -fPIC $LDFLAGS -o $TERMUX_PREFIX/lib/libunibilium.so unibilium.o uninames.o uniutil.o
	cp unibilium.h $TERMUX_PREFIX/include/

	mkdir -p $PKG_CONFIG_LIBDIR
	sed "s|@VERSION@|$TERMUX_PKG_VERSION|" unibilium.pc.in | \
		sed "s|@INCDIR@|$TERMUX_PREFIX/include|" | \
		sed "s|@LIBDIR@|$TERMUX_PREFIX/lib|" > \
		$PKG_CONFIG_LIBDIR/unibilium.pc
}
