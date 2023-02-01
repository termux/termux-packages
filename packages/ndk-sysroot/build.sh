TERMUX_PKG_HOMEPAGE=https://developer.android.com/tools/sdk/ndk/index.html
TERMUX_PKG_DESCRIPTION="System header and library files from the Android NDK needed for compiling C programs"
TERMUX_PKG_LICENSE="NCSA"
TERMUX_PKG_MAINTAINER="@termux"
# Version should be equal to TERMUX_NDK_{VERSION_NUM,REVISION} in
# scripts/properties.sh
TERMUX_PKG_VERSION=25c
TERMUX_PKG_SRCURL=https://dl.google.com/android/repository/android-ndk-r${TERMUX_PKG_VERSION}-linux.zip
TERMUX_PKG_SHA256=769ee342ea75f80619d985c2da990c48b3d8eaf45f48783a2d48870d04b46108
# This package has taken over <pty.h> from the previous libutil-dev
# and iconv.h from libandroid-support-dev:
TERMUX_PKG_CONFLICTS="libutil-dev, libgcc, libandroid-support-dev"
TERMUX_PKG_REPLACES="libutil-dev, libgcc, libandroid-support-dev, ndk-stl"
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_RM_AFTER_INSTALL="
include/EGL
include/GLES
include/GLES2
include/GLES3
include/KHR/khrplatform.h
include/execinfo.h
include/glob.h
include/iconv.h
include/spawn.h
include/sys/capability.h
include/sys/sem.h
include/sys/shm.h
include/unicode
include/vulkan
include/zconf.h
include/zlib.h
"

termux_step_post_get_source() {
	pushd toolchains/llvm/prebuilt/linux-x86_64/sysroot/
	for patch in $TERMUX_SCRIPTDIR/ndk-patches/$TERMUX_PKG_VERSION/*.patch; do
		echo "Applying ndk patch: $(basename $patch)"
		test -f "$patch" && sed \
			-e "s%\@TERMUX_APP_PACKAGE\@%${TERMUX_APP_PACKAGE}%g" \
			-e "s%\@TERMUX_BASE_DIR\@%${TERMUX_BASE_DIR}%g" \
			-e "s%\@TERMUX_CACHE_DIR\@%${TERMUX_CACHE_DIR}%g" \
			-e "s%\@TERMUX_HOME\@%${TERMUX_ANDROID_HOME}%g" \
			-e "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" \
			"$patch" | patch --silent -p1
	done
	sed -i "s/define __ANDROID_API__ __ANDROID_API_FUTURE__/define __ANDROID_API__ $TERMUX_PKG_API_LEVEL/" \
		usr/include/android/api-level.h
	grep -lrw usr/include/c++/v1 -e '<version>' | xargs -n 1 sed -i 's/<version>/\"version\"/g'
	popd
}

termux_step_make_install() {
	mkdir -p $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/lib \
		$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/include

	cp -Rf toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include/* \
		$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/include


	find $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/include -name \*.orig -delete

	cp $TERMUX_SCRIPTDIR/ndk-patches/{langinfo,libintl}.h $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/include/

	cp toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/lib/$TERMUX_HOST_PLATFORM/$TERMUX_PKG_API_LEVEL/*.o \
		$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/lib

	if [ $TERMUX_ARCH == "i686" ]; then
		LIBATOMIC=toolchains/llvm/prebuilt/linux-x86_64/lib64/clang/*/lib/linux/i386
	elif [ $TERMUX_ARCH == "arm64" ]; then
		LIBATOMIC=toolchains/llvm/prebuilt/linux-x86_64/lib64/clang/*/lib/linux/aarch64
	else
		LIBATOMIC=toolchains/llvm/prebuilt/linux-x86_64/lib64/clang/*/lib/linux/$TERMUX_ARCH
	fi

	cp $LIBATOMIC/libatomic.a $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/lib/

	cp toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/lib/$TERMUX_HOST_PLATFORM/libcompiler_rt-extras.a \
		$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/lib/
	# librt and libpthread are built into libc on android, so setup them as symlinks
	# to libc for compatibility with programs that users try to build:
	local _SYSTEM_LIBDIR=/system/lib64
	if [ $TERMUX_ARCH_BITS = 32 ]; then _SYSTEM_LIBDIR=/system/lib; fi
	NDK_ARCH=$TERMUX_ARCH
	test $NDK_ARCH == 'i686' && NDK_ARCH='i386'

	mkdir -p $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/lib
	# clang 13 requires libunwind on Android.
	cp toolchains/llvm/prebuilt/linux-x86_64/lib64/clang/14.0.7/lib/linux/$NDK_ARCH/libunwind.a \
		$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/lib
	for lib in librt.so libpthread.so libutil.so; do
		echo 'INPUT(-lc)' > $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/lib/$lib
	done
	unset lib
}
