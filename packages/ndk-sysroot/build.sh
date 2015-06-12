TERMUX_PKG_HOMEPAGE=https://developer.android.com/tools/sdk/ndk/index.html
TERMUX_PKG_DESCRIPTION="System header and library files from the Android NDK needed for compiling C programs"
TERMUX_PKG_VERSION=$TERMUX_NDK_VERSION
TERMUX_PKG_NO_DEVELSPLIT=yes

termux_step_extract_into_massagedir () {
	mkdir -p $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/lib/pkgconfig $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/include
	cp -Rf $TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/include/* $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/include
	cp $TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib/*.o $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/lib

	cat > $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/lib/pkgconfig/zlib.pc <<HERE
Name: zlib
Description: zlib compression library
Version: 1.2.3

Requires:
Libs: -L$TERMUX_PREFIX/lib -lz
Cflags: -I$TERMUX_PREFIX/include
HERE
}
