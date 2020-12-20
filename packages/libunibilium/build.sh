TERMUX_PKG_HOMEPAGE=https://github.com/neovim/unibilium
TERMUX_PKG_DESCRIPTION="Terminfo parsing library"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.1.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/neovim/unibilium/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=05bf97e357615e218126f7ac086e7056a23dc013cfac71643b50a18ad390c7d4
TERMUX_PKG_BREAKS="libunibilium-dev"
TERMUX_PKG_REPLACES="libunibilium-dev"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	rm -f CMakeLists.txt
}

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
