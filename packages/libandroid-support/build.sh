TERMUX_PKG_HOMEPAGE=https://developer.android.com/tools/sdk/ndk/index.html
TERMUX_PKG_DESCRIPTION="Library extending the Android C library (Bionic) for additional multibyte, locale and math support"
# Increase last digit each time a patch changes.
TERMUX_PKG_VERSION=${TERMUX_NDK_VERSION}.9
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_ESSENTIAL=yes

termux_step_post_extract_package () {
        cd $TERMUX_PKG_SRCDIR
	mkdir -p src/musl-locale/ src/musl-multibyte/ include/ src/musl-ctype/
	cp $NDK/sources/android/support/src/musl-multibyte/{mblen.c,mbsrtowcs.c,mbsnrtowcs.c,libc.h,internal.h,internal.c} src/musl-multibyte/
	cp $NDK/sources/android/support/src/musl-locale/{catclose.c,catgets.c,catopen.c} src/musl-locale/
	cp $NDK/sources/android/support/src/musl-locale/{langinfo.c,intl.c,iconv.c,strfmon.c} src/musl-locale/
	cp $NDK/sources/android/support/src/musl-ctype/* src/musl-ctype/

	cp $NDK/sources/android/support/include/* include/
	cp $NDK/sources/android/support/src/musl-locale/{libc.h,codepages.h,legacychars.h,jis0208.h,gb18030.h,big5.h,hkscs.h,ksc.h} include/
}

termux_step_make_install () {
	_C_FILES="src/musl-*/*.c"
	# Link against libm to avoid linkers having to do it
        $CC $CFLAGS -std=c99 -DNULL=0 $CPPFLAGS $LDFLAGS -lm \
                -Iinclude -Isrc/locale \
		$_C_FILES \
                -shared -fpic \
                -o libandroid-support.so

        cp libandroid-support.so $TERMUX_PREFIX/lib/

        (cd $TERMUX_PREFIX/lib; rm -f libiconv.so libintl.so; ln -s libandroid-support.so libiconv.so; ln -s libandroid-support.so libintl.so)

	rm -Rf $TERMUX_PREFIX/include/libandroid-support
	mkdir -p $TERMUX_PREFIX/include/libandroid-support
	cp -Rf include/* $TERMUX_PREFIX/include/libandroid-support/

        (cd $TERMUX_PREFIX/include; rm -f libintl.h iconv.h; ln -s libandroid-support/libintl.h libintl.h; ln -s libandroid-support/iconv.h iconv.h)
}
