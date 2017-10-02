TERMUX_PKG_HOMEPAGE=https://github.com/mauke/unibilium
TERMUX_PKG_DESCRIPTION="Terminfo parsing library"
TERMUX_PKG_VERSION=1.2.1
TERMUX_PKG_SHA256=6045b4f6adca7b1123284007675ca71f718f70942d3a93d8b9fa5bd442006ec1
TERMUX_PKG_SRCURL=https://github.com/mauke/unibilium/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_make () {
	return
}

termux_step_make_install () {
	CFLAGS+=" -DTERMINFO_DIRS=\"$TERMUX_PREFIX/share/terminfo/\""
	$CC $CFLAGS -c -fPIC unibilium.c -o unibilium.o
	$CC $CFLAGS -c -fPIC uninames.c -o uninames.o
	$CC $CFLAGS -c -fPIC uniutil.c -o uniutil.o
	$CC -shared -fPIC $LDFLAGS -o $TERMUX_PREFIX/lib/libunibilium.so unibilium.o uninames.o uniutil.o
	cp unibilium.h $TERMUX_PREFIX/include/
}
