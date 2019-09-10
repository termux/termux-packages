TERMUX_PKG_HOMEPAGE=https://developer.android.com/tools/sdk/ndk/index.html
TERMUX_PKG_DESCRIPTION="Multilib binaries for cross-compilation"
TERMUX_PKG_LICENSE="NCSA"
TERMUX_PKG_VERSION=$TERMUX_NDK_VERSION
TERMUX_PKG_REVISION=2
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_NO_STATICSPLIT=true

prepare_libs() {
	local ARCH="$1"
	local SUFFIX="$2"
	local NDK_SUFFIX=$SUFFIX

	if [ $ARCH = x86 ] || [ $ARCH = x86_64 ]; then
	    NDK_SUFFIX=$ARCH
	fi

	mkdir -p $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/$SUFFIX/lib
	local BASEDIR=$NDK/platforms/android-${TERMUX_PKG_API_LEVEL}/arch-$ARCH/usr/lib
	if [ $ARCH = x86_64 ]; then BASEDIR+="64"; fi
	cp $BASEDIR/*.o $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/$SUFFIX/lib
	cp $BASEDIR/lib{c,dl,log,m}.so $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/$SUFFIX/lib
	cp $BASEDIR/lib{c,dl,m}.a $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/$SUFFIX/lib
	cp $TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib/aarch64-linux-android/libc++_shared.so $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/$SUFFIX/lib

	LIBATOMIC=$NDK/toolchains/${NDK_SUFFIX}-*/prebuilt/linux-*/${SUFFIX}/lib
	if [ $ARCH = "arm64" ] || [ $ARCH = "x86_64" ]; then LIBATOMIC+="64"; fi
	if [ $ARCH = "arm" ]; then LIBATOMIC+="/armv7-a"; fi
	cp $LIBATOMIC/libatomic.a $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/$SUFFIX/lib/

	LIBGCC=$NDK/toolchains/${NDK_SUFFIX}-*/prebuilt/linux-*/lib/gcc/${SUFFIX}/4.9.x
	if [ $ARCH = "arm" ]; then LIBGCC+="/armv7-a"; fi
	cp $LIBGCC/libgcc.a $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/$SUFFIX/lib/
}

termux_step_extract_into_massagedir() {
	prepare_libs "arm" "arm-linux-androideabi"
	prepare_libs "arm64" "aarch64-linux-android"
	prepare_libs "x86" "i686-linux-android"
	prepare_libs "x86_64" "x86_64-linux-android"
}
