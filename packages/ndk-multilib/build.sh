TERMUX_PKG_HOMEPAGE=https://developer.android.com/tools/sdk/ndk/index.html
TERMUX_PKG_DESCRIPTION="Multilib binaries for cross-compilation"
TERMUX_PKG_LICENSE="NCSA"
TERMUX_PKG_MAINTAINER="@termux"
# Version should be equal to TERMUX_NDK_{VERSION_NUM,REVISION} in
# scripts/properties.sh
TERMUX_PKG_VERSION=29
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://dl.google.com/android/repository/android-ndk-r${TERMUX_PKG_VERSION}-linux.zip
TERMUX_PKG_SHA256=4abbbcdc842f3d4879206e9695d52709603e52dd68d3c1fff04b3b5e7a308ecf
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_BUILD_IN_SRC=true
NDK_MULTILIB_SHARED_LIBS=(
	lib{android,c,dl,log,m}.so
	lib{EGL,GLESv1_CM,GLESv2,GLESv3}.so
	lib{vulkan,OpenMAXAL,OpenSLES}.so
)
NDK_MULTILIB_STATIC_LIBS=(
	lib{c,dl,m}.a
)

termux_step_get_source() {
	mkdir -p "$TERMUX_PKG_SRCDIR"
	if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ]; then
		termux_download_src_archive
		cd $TERMUX_PKG_TMPDIR
		termux_extract_src_archive
		mv "$TERMUX_PKG_SRCDIR/android-ndk-r$TERMUX_PKG_VERSION"/* "$TERMUX_PKG_SRCDIR"
	else
		local lib_path="toolchains/llvm/prebuilt/linux-x86_64/sysroot"
		mkdir -p "$TERMUX_PKG_SRCDIR"/"$lib_path"
		cp -fr "$NDK"/"$lib_path"/* "$TERMUX_PKG_SRCDIR"/"$lib_path"/
		lib_path="toolchains/llvm/prebuilt/linux-x86_64/lib"
		mkdir -p "$TERMUX_PKG_SRCDIR"/"$lib_path"
		cp -fr "$NDK"/"$lib_path"/* "$TERMUX_PKG_SRCDIR"/"$lib_path"/
	fi
}

prepare_libs() {
	local ARCH="$1"
	local SUFFIX="$2"
	local NDK_SUFFIX=$SUFFIX

	if [ $ARCH = x86 ] || [ $ARCH = x86_64 ]; then
		NDK_SUFFIX=$ARCH
	fi

	mkdir -p $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/$SUFFIX/lib
	mkdir -p $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/opt/ndk-multilib/$SUFFIX/lib
	local BASEDIR=toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/lib/$SUFFIX/
	cp $BASEDIR/${TERMUX_PKG_API_LEVEL}/*.o $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/$SUFFIX/lib

	local f
	for f in "${NDK_MULTILIB_SHARED_LIBS[@]}"; do
		cp $BASEDIR/${TERMUX_PKG_API_LEVEL}/${f} $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/opt/ndk-multilib/$SUFFIX/lib
	done

	cp $BASEDIR/libc++_shared.so $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/$SUFFIX/lib
	for f in "${NDK_MULTILIB_STATIC_LIBS[@]}"; do
		cp $BASEDIR/${f} $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/opt/ndk-multilib/$SUFFIX/lib
	done
	cp $BASEDIR/lib{c++_static,c++abi,c++experimental}.a $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/$SUFFIX/lib
	echo 'INPUT(-lc++_static -lc++abi)' > $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/$SUFFIX/lib/libc++_shared.a

	for f in "${NDK_MULTILIB_SHARED_LIBS[@]}" "${NDK_MULTILIB_STATIC_LIBS[@]}"; do
		ln -sfT $TERMUX_PREFIX/opt/ndk-multilib/$SUFFIX/lib/${f} \
			$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/$SUFFIX/lib/${f}
	done

	if [ $ARCH == "x86" ]; then
		LIBATOMIC=toolchains/llvm/prebuilt/linux-x86_64/lib/clang/*/lib/linux/i386
	elif [ $ARCH == "arm64" ]; then
		LIBATOMIC=toolchains/llvm/prebuilt/linux-x86_64/lib/clang/*/lib/linux/aarch64
	else
		LIBATOMIC=toolchains/llvm/prebuilt/linux-x86_64/lib/clang/*/lib/linux/$ARCH
	fi

	cp $LIBATOMIC/libatomic.a $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/$SUFFIX/lib/

	cp $LIBATOMIC/libunwind.a $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/$SUFFIX/lib/
}

add_cross_compiler_rt() {
	RT_PREFIX=toolchains/llvm/prebuilt/linux-x86_64/lib/clang/*/lib/linux
	RT_OPT_DIR=$TERMUX_PREFIX/opt/ndk-multilib/cross-compiler-rt
	mkdir -p $TERMUX_PKG_MASSAGEDIR/$RT_OPT_DIR
	cp $RT_PREFIX/* $TERMUX_PKG_MASSAGEDIR/$RT_OPT_DIR || true
}

termux_step_make_install() {
	prepare_libs "arm" "arm-linux-androideabi"
	prepare_libs "arm64" "aarch64-linux-android"
	prepare_libs "x86" "i686-linux-android"
	prepare_libs "x86_64" "x86_64-linux-android"
	add_cross_compiler_rt
}

termux_step_post_massage() {
	local triple f
	for triple in aarch64-linux-android arm-linux-androideabi i686-linux-android x86_64-linux-android; do
		for f in "${NDK_MULTILIB_SHARED_LIBS[@]}" "${NDK_MULTILIB_STATIC_LIBS[@]}"; do
			rm -f ${triple}/lib/${f}
		done
	done
}

termux_step_create_debscripts() {
	local f
	for f in postinst prerm; do
		sed -e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
			-e "s|@TERMUX_PACKAGE_FORMAT@|${TERMUX_PACKAGE_FORMAT}|g" \
			$TERMUX_PKG_BUILDER_DIR/postinst-header.in > "${f}"
	done

	ndk_multilib_alien() {
		sed -e "s|@COMMAND@|${1}|" \
			-e "s|@NDK_MULTILIB_SHARED_LIBS@|${NDK_MULTILIB_SHARED_LIBS[*]}|g" \
			-e "s|@NDK_MULTILIB_STATIC_LIBS@|${NDK_MULTILIB_STATIC_LIBS[*]}|g" \
			$TERMUX_PKG_BUILDER_DIR/postinst-alien.in
	}
	ndk_multilib_alien 'ln -sf "'$TERMUX_PREFIX'/opt/ndk-multilib/$triple/lib/$so" "'$TERMUX_PREFIX'/\$triple/lib"' >> postinst
	ndk_multilib_alien 'rm -f "'$TERMUX_PREFIX'/$triple/lib/$so"' >> prerm

	chmod 0700 postinst prerm
}
