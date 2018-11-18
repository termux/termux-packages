TERMUX_PKG_HOMEPAGE=https://github.com/termux/libandroid-support
TERMUX_PKG_DESCRIPTION="Library extending the Android C library (Bionic) for additional multibyte, locale and math support"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=22
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=667f20d0821a6305c50c667363486d546b293e846f31d02f559947d50121f51e
TERMUX_PKG_SRCURL=https://github.com/termux/libandroid-support/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_ESSENTIAL=yes

termux_step_make_install () {
	_C_FILES="src/musl-*/*.c"
	$CC $CFLAGS -std=c99 -DNULL=0 $CPPFLAGS $LDFLAGS \
		-Iinclude \
		$_C_FILES \
		-shared -fpic \
		-o $TERMUX_PREFIX/lib/libandroid-support.so

	ln -sf libandroid-support.so $TERMUX_PREFIX/lib/libiconv.so

	rm -Rf $TERMUX_PREFIX/include/libandroid-support/
	cp --remove-destination include/*.h $TERMUX_PREFIX/include/
}
