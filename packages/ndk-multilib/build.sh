TERMUX_PKG_HOMEPAGE=https://developer.android.com/tools/sdk/ndk/index.html
TERMUX_PKG_DESCRIPTION="Multilib binaries for cross-compilation"
TERMUX_PKG_LICENSE="NCSA"
TERMUX_PKG_MAINTAINER="@termux"
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
	local BASEDIR=$NDK/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/lib/$SUFFIX/${TERMUX_PKG_API_LEVEL}
	cp $BASEDIR/*.o $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/$SUFFIX/lib
	cp $BASEDIR/lib{c,dl,log,m}.so $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/$SUFFIX/lib
	cp $BASEDIR/lib{c,dl,m}.a $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/$SUFFIX/lib
	cp $TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib/${SUFFIX}/libc++_shared.so \
		$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/$SUFFIX/lib
	cp $TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib/${SUFFIX}/lib{c++_static,c++abi}.a \
		$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/$SUFFIX/lib
	echo 'INPUT(-lc++_static -lc++abi)' > $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/$SUFFIX/lib/libc++_shared.a

	if [ $ARCH == "x86" ]; then
		LIBATOMIC=$NDK/toolchains/llvm/prebuilt/linux-x86_64/lib64/clang/*/lib/linux/i386
	elif [ $ARCH == "arm64" ]; then
		LIBATOMIC=$NDK/toolchains/llvm/prebuilt/linux-x86_64/lib64/clang/*/lib/linux/aarch64
	else
		LIBATOMIC=$NDK/toolchains/llvm/prebuilt/linux-x86_64/lib64/clang/*/lib/linux/$ARCH
	fi

	cp $LIBATOMIC/libatomic.a $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/$SUFFIX/lib/

	cp $LIBATOMIC/libunwind.a $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/$SUFFIX/lib/
}

add_cross_compiler_rt() {
	RT_PREFIX=$NDK/toolchains/llvm/prebuilt/linux-x86_64/lib64/clang/*/lib/linux
	RT_OPT_DIR=$TERMUX_PREFIX/opt/ndk-multilib/cross-compiler-rt
	LIBLLVM_VERSION=$(. $TERMUX_SCRIPTDIR/packages/libllvm/build.sh; echo $TERMUX_PKG_VERSION)
	RT_PATH=$TERMUX_PREFIX/lib/clang/$LIBLLVM_VERSION/lib/android
	mkdir -p $TERMUX_PKG_MASSAGEDIR/$RT_OPT_DIR
	cp $RT_PREFIX/* $TERMUX_PKG_MASSAGEDIR/$RT_OPT_DIR || true
	# Reserve this folder to make its existance be handled by dpkg.
	mkdir -p $TERMUX_PKG_MASSAGEDIR/$RT_PATH
	touch $TERMUX_PKG_MASSAGEDIR/$RT_PATH/.keep-ndk-multilib
}

termux_step_extract_into_massagedir() {
	prepare_libs "arm" "arm-linux-androideabi"
	prepare_libs "arm64" "aarch64-linux-android"
	prepare_libs "x86" "i686-linux-android"
	prepare_libs "x86_64" "x86_64-linux-android"
	add_cross_compiler_rt
}

termux_step_create_debscripts() {
	# Install the symlinks.
	cat <<- POSTINST_EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	echo "Installing symlinks to $RT_PATH..."
	find $RT_OPT_DIR -type f ! -name "libclang_rt*\$(dpkg --print-architecture)*" -exec ln -sf "{}" $RT_PATH \;
	exit 0
	POSTINST_EOF

	# Uninstall the symlinks.
	cat <<- PRERM_EOF > ./prerm
	#!$TERMUX_PREFIX/bin/sh
	if [ "$TERMUX_PACKAGE_FORMAT" != "pacman" ] && [ "\$1" != "remove" ]; then
	    exit 0
	fi
	echo "Uninstalling symlinks..."
	find $RT_PATH -type l ! -name "libclang_rt*\$(dpkg --print-architecture)*" -exec rm -rf "{}" \;
	exit 0
	PRERM_EOF

	chmod 0755 postinst prerm
}
