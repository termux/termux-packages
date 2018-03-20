TERMUX_PKG_HOMEPAGE=https://developer.android.com/tools/sdk/ndk/index.html
TERMUX_PKG_DESCRIPTION="System header and library files from the Android NDK needed for compiling C programs"
TERMUX_PKG_VERSION=$TERMUX_NDK_VERSION
TERMUX_PKG_REVISION=8
TERMUX_PKG_NO_DEVELSPLIT=yes
# Depend on libandroid-support-dev so that iconv.h and libintl.h are available:
TERMUX_PKG_DEPENDS="libandroid-support-dev"
TERMUX_PKG_KEEP_STATIC_LIBRARIES="true"
# This package has taken over <pty.h> from the previous libutil-dev:
TERMUX_PKG_CONFLICTS="libutil-dev, libgcc"
TERMUX_PKG_REPLACES="libutil-dev, libgcc"

termux_step_extract_into_massagedir () {
	mkdir -p $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/lib/pkgconfig \
		$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/include

	cp -Rf $TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/include/* \
		$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/include

	local _LIBDIR=lib
	if [ "$TERMUX_ARCH" = "x86_64" ]; then
		_LIBDIR=lib64
	fi
	cp $TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/${_LIBDIR}/*.o \
		$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/lib

	cp "$PKG_CONFIG_LIBDIR/zlib.pc" \
		$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/lib/pkgconfig/zlib.pc

	local LIBATOMIC_PATH=$TERMUX_STANDALONE_TOOLCHAIN/$TERMUX_HOST_PLATFORM/lib
	if [ $TERMUX_ARCH_BITS = 64 ]; then LIBATOMIC_PATH+="64"; fi
	if [ $TERMUX_ARCH = "arm" ]; then LIBATOMIC_PATH+="/armv7-a"; fi
	LIBATOMIC_PATH+="/libatomic.a"
	cp $LIBATOMIC_PATH $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/lib/

	local LIBGCC_PATH=$TERMUX_STANDALONE_TOOLCHAIN/lib/gcc/$TERMUX_HOST_PLATFORM/4.9.x
	if [ $TERMUX_ARCH = "arm" ]; then LIBGCC_PATH+="/armv7-a"; fi
	LIBGCC_PATH+="/libgcc.a"
	cp $LIBGCC_PATH $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/lib/

	# librt and libpthread are built into libc on android, so setup them as symlinks
	# to libc for compatibility with programs that users try to build:
	local _SYSTEM_LIBDIR=/system/lib64
	if [ $TERMUX_ARCH_BITS = 32 ]; then _SYSTEM_LIBDIR=/system/lib; fi
	mkdir -p $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/lib
	cd $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/lib
	ln -f -s $_SYSTEM_LIBDIR/libc.so librt.so
	ln -f -s $_SYSTEM_LIBDIR/libc.so libpthread.so
}
