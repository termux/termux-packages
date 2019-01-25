TERMUX_PKG_HOMEPAGE=https://github.com/termux/libandroid-support
TERMUX_PKG_DESCRIPTION="Library extending the Android C library (Bionic) for additional multibyte, locale and math support"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=23
TERMUX_PKG_SHA256=9683eccb6da260715babd56c8f2b8e48b21caf3f6e878bd80c631f3b9d76e13f
TERMUX_PKG_SRCURL=https://github.com/termux/libandroid-support/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_ESSENTIAL=yes

termux_step_make_install () {
	# Remove file previously in package to avoid this being left
	# in build environments.
	rm -f $TERMUX_PREFIX/include/langinfo.h

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
