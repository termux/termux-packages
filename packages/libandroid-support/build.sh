TERMUX_PKG_HOMEPAGE=https://github.com/termux/libandroid-support
TERMUX_PKG_DESCRIPTION="Library extending the Android C library (Bionic) for additional multibyte, locale and math support"
TERMUX_PKG_VERSION=19
TERMUX_PKG_SRCURL=https://github.com/termux/libandroid-support/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5499dd66a0df3654d2cd1d075de7dccf3ed9d24dafb8c4ada7aa3faadc3a0dbe
TERMUX_PKG_FOLDERNAME=libandroid-support-$TERMUX_PKG_VERSION
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_ESSENTIAL=yes

termux_step_make_install () {
	_C_FILES="src/musl-*/*.c"
	$CC $CFLAGS -std=c99 -DNULL=0 $CPPFLAGS $LDFLAGS \
		-Iinclude \
		$_C_FILES \
		-shared -fpic \
		-o libandroid-support.so

	cp libandroid-support.so $TERMUX_PREFIX/lib/

	(cd $TERMUX_PREFIX/lib; ln -f -s libandroid-support.so libiconv.so; ln -f -s libandroid-support.so libintl.so)

	rm -Rf $TERMUX_PREFIX/include/libandroid-support
	mkdir -p $TERMUX_PREFIX/include/libandroid-support
	cp -Rf include/* $TERMUX_PREFIX/include/libandroid-support/

	(cd $TERMUX_PREFIX/include; ln -f -s libandroid-support/libintl.h libintl.h; ln -f -s libandroid-support/iconv.h iconv.h)
}
