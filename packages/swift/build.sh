TERMUX_PKG_HOMEPAGE=https://swift.org/
TERMUX_PKG_DESCRIPTION="Swift is a high-performance system programming language"
TERMUX_PKG_LICENSE="Apache-2.0, NCSA"
TERMUX_PKG_VERSION=5.2.5
TERMUX_PKG_REVISION=2
SWIFT_RELEASE="RELEASE"
TERMUX_PKG_SRCURL=https://github.com/apple/swift/archive/swift-$TERMUX_PKG_VERSION-$SWIFT_RELEASE.tar.gz
TERMUX_PKG_SHA256=2353bb00dada11160945729a33af94150b7cf0a6a38fbe975774a6e244dbc548
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_DEPENDS="binutils-gold, clang, libc++, ndk-sysroot, libandroid-glob, libandroid-spawn, libcurl, libicu, libicu-static, libsqlite, libuuid, libxml2, libdispatch, llbuild"
TERMUX_PKG_BUILD_DEPENDS="cmake, ninja, perl, pkg-config, python2, rsync"
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686, x86_64"
TERMUX_PKG_NO_STATICSPLIT=true

SWIFT_COMPONENTS="autolink-driver;compiler;clang-resource-dir-symlink;swift-remote-mirror;parser-lib;license;sourcekit-inproc"
SWIFT_TOOLCHAIN_FLAGS="-R --no-assertions --llvm-targets-to-build='X86;ARM;AArch64' -j $TERMUX_MAKE_PROCESSES"
SWIFT_PATH_FLAGS="--build-subdir=. --install-destdir=/ --install-prefix=$TERMUX_PREFIX"

if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ]; then
SWIFT_BUILD_FLAGS="--build-swift-static-stdlib --swift-install-components='$SWIFT_COMPONENTS;stdlib;sdk-overlay'"
else
SWIFT_BIN="swift-$TERMUX_PKG_VERSION-$SWIFT_RELEASE-ubuntu20.04"
SWIFT_BINDIR="$TERMUX_PKG_HOSTBUILD_DIR/$SWIFT_BIN/usr/bin"
SWIFT_ANDROID_NDK_FLAGS="--android --android-ndk $TERMUX_STANDALONE_TOOLCHAIN --android-arch $TERMUX_ARCH
--android-api-level $TERMUX_PKG_API_LEVEL --android-icu-uc $TERMUX_PREFIX/lib/libicuuc.so
--android-icu-uc-include $TERMUX_PREFIX/include/ --android-icu-i18n $TERMUX_PREFIX/lib/libicui18n.so
--android-icu-i18n-include $TERMUX_PREFIX/include/ --android-icu-data $TERMUX_PREFIX/lib/libicudata.so"
SWIFT_BUILD_FLAGS="$SWIFT_ANDROID_NDK_FLAGS --build-toolchain-only --skip-build-android
--cross-compile-hosts=android-$TERMUX_ARCH --swift-install-components='$SWIFT_COMPONENTS'
--native-swift-tools-path=$SWIFT_BINDIR --native-clang-tools-path=$TERMUX_STANDALONE_TOOLCHAIN/bin
--build-swift-dynamic-stdlib=0 --build-swift-dynamic-sdk-overlay=0 --skip-local-build
--skip-local-host-install"
fi

termux_step_post_get_source() {
	if [ "$TERMUX_PKG_QUICK_REBUILD" = "false" ]; then
		# The Swift build-script requires a particular organization of source directories,
		# which the following sets up.
		mkdir .temp
		mv [a-zA-Z]* .temp/
		mv .temp swift

		declare -A library_checksums
		library_checksums[swift-cmark]=71ef5641ebbb60ddd609320bdbf4d378cdcd89941b6f17f658ee5be40c98a232
		library_checksums[llvm-project]=f3e6bf2657edf7c290befdfc9d534ed776c0f344c0df373ccecc60ab2c928a51
		library_checksums[swift-corelibs-libdispatch]=df86f7cf005b9f06f365f5d39bc952ecc50ffc11f2382ab12b46fed2b83bb26e
		library_checksums[swift-corelibs-foundation]=47961693711812f6e0a2525192aebdf1aa7a08323f6061e3defcd1639d09b429
		library_checksums[swift-corelibs-xctest]=37c1dec78fab3f98a9f106d4d4a7f35268004f4c1e157ab97a6c76aa4dbcb845
		library_checksums[swift-llbuild]=07db561275697634f4790d9cd7d817272ffa37ebd7a69e0abc5de51bcdb4efb7
		library_checksums[swift-package-manager]=f7197556bf299f4fc7b88e63fed78797fd85f94bf590f34e3de845ad5e62afbe

		for library in "${!library_checksums[@]}"; do \
			termux_download \
				https://github.com/apple/$library/archive/swift-$TERMUX_PKG_VERSION-$SWIFT_RELEASE.tar.gz \
				$TERMUX_PKG_CACHEDIR/$library-$TERMUX_PKG_VERSION.tar.gz \
				${library_checksums[$library]}
			tar xf $TERMUX_PKG_CACHEDIR/$library-$TERMUX_PKG_VERSION.tar.gz
			mv $library-swift-${TERMUX_PKG_VERSION}-$SWIFT_RELEASE $library
		done

		mv swift-cmark cmark
		mv swift-llbuild llbuild
		mv swift-package-manager swiftpm

		if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
			termux_download \
				https://swift.org/builds/swift-$TERMUX_PKG_VERSION-release/ubuntu2004/swift-$TERMUX_PKG_VERSION-$SWIFT_RELEASE/$SWIFT_BIN.tar.gz \
				$TERMUX_PKG_CACHEDIR/$SWIFT_BIN.tar.gz \
				1350f1775469bc129dc4b53e324c5748c5f63eff922c581faf38a02e41e4bb15
		fi

		# The Swift compiler searches for the clang headers so symlink against them.
		export TERMUX_CLANG_VERSION=$(grep ^TERMUX_PKG_VERSION= $TERMUX_PKG_BUILDER_DIR/../libllvm/build.sh | cut -f2 -d=)
		sed "s%\@TERMUX_CLANG_VERSION\@%${TERMUX_CLANG_VERSION}%g" $TERMUX_PKG_BUILDER_DIR/swift-stdlib-public-SwiftShims-CMakeLists.txt | \
			patch -p1

		# The Swift build scripts still depend on Python 2, so make sure it's used.
		ln -s $(command -v python2) $TERMUX_PKG_BUILDDIR/python
	fi
	export PATH=$TERMUX_PKG_BUILDDIR:$PATH
}

termux_step_host_build() {
	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		if [ "$TERMUX_PKG_QUICK_REBUILD" = "false" ]; then
			tar xf $TERMUX_PKG_CACHEDIR/$SWIFT_BIN.tar.gz
		fi

		termux_setup_cmake
		termux_setup_ninja
		termux_setup_standalone_toolchain

		local CLANG=$(command -v clang)
		local CLANGXX=$(command -v clang++)

		# The Ubuntu CI may not have clang/clang++ in its path so explicitly set it
		# to clang-10 instead.
		if [ -z "$CLANG" ]; then
			CLANG=$(command -v clang-10)
			CLANGXX=$(command -v clang++-10)
		fi

		# Natively compile llvm-tblgen and some other files needed later, and cross-compile
		# the Swift stdlib.
		SWIFT_BUILD_ROOT=$TERMUX_PKG_BUILDDIR $TERMUX_PKG_SRCDIR/swift/utils/build-script \
		-R --no-assertions -j $TERMUX_MAKE_PROCESSES $SWIFT_ANDROID_NDK_FLAGS $SWIFT_PATH_FLAGS \
		--build-runtime-with-host-compiler --skip-build-llvm --build-swift-tools=0 \
		--native-swift-tools-path=$SWIFT_BINDIR --native-llvm-tools-path=$SWIFT_BINDIR \
		--native-clang-tools-path=$SWIFT_BINDIR --build-swift-static-stdlib \
		--build-swift-static-sdk-overlay --stdlib-deployment-targets=android-$TERMUX_ARCH \
		--swift-primary-variant-sdk=ANDROID --swift-primary-variant-arch=$TERMUX_ARCH \
		--swift-install-components="stdlib;sdk-overlay" --install-swift \
		--host-cc=$CLANG --host-cxx=$CLANGXX

		cp $TERMUX_PREFIX/lib/swift/android/$TERMUX_ARCH/glibc.modulemap \
			$TERMUX_PKG_BUILDDIR/glibc-native.modulemap

		# This is installed later with the compiler, but it's needed before that
		# to cross-compile the corelibs.
		ln -s ../clang/$TERMUX_CLANG_VERSION $TERMUX_PREFIX/lib/swift/clang
	fi
}

termux_step_pre_configure() {
	if [ "$TERMUX_PKG_QUICK_REBUILD" = "false" ]; then
		cd llbuild
		# A single patch needed from the existing llbuild package
		patch -p1 < $TERMUX_PKG_BUILDER_DIR/../llbuild/lib-llvm-Support-CmakeLists.txt.patch

		cd ../llvm-project
		patch -p2 < $TERMUX_PKG_BUILDER_DIR/../libllvm/tools-clang-lib-Driver-ToolChain.cpp.patch
		cd llvm
		patch -p1 < $TERMUX_PKG_BUILDER_DIR/../libllvm/include-llvm-ADT-Triple.h.patch
		cd ../..

		sed "s%\@TERMUX_STANDALONE_TOOLCHAIN\@%${TERMUX_STANDALONE_TOOLCHAIN}%g" \
		$TERMUX_PKG_BUILDER_DIR/swift-utils-build-script-impl | \
		sed "s%\@TERMUX_PKG_API_LEVEL\@%${TERMUX_PKG_API_LEVEL}%g" | \
		sed "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" | \
		sed "s%\@TERMUX_ARCH\@%${TERMUX_ARCH}%g" | patch -p1

		sed "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" \
		$TERMUX_PKG_BUILDER_DIR/swiftpm-Utilities-bootstrap | \
		sed "s%\@TERMUX_PKG_BUILDDIR\@%${TERMUX_PKG_BUILDDIR}%g" | \
		sed "s%\@TERMUX_ARCH\@%${TERMUX_ARCH}%g" | patch -p1

		sed "s%\@TERMUX_STANDALONE_TOOLCHAIN\@%${TERMUX_STANDALONE_TOOLCHAIN}%g" \
		$TERMUX_PKG_BUILDER_DIR/swiftpm-android-flags.json | \
		sed "s%\@CCTERMUX_HOST_PLATFORM\@%${CCTERMUX_HOST_PLATFORM}%g" | \
		sed "s%\@TERMUX_HOST_PLATFORM\@%${TERMUX_HOST_PLATFORM}%g" | \
		sed "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" | \
		sed "s%\@TERMUX_ARCH\@%${TERMUX_ARCH}%g" > $TERMUX_PKG_BUILDDIR/swiftpm-android-flags.json
	fi
}

termux_step_make() {
	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		export TERMUX_SWIFT_FLAGS="-target $CCTERMUX_HOST_PLATFORM \
		-resource-dir $TERMUX_PREFIX/lib/swift -sdk $TERMUX_STANDALONE_TOOLCHAIN/sysroot \
		-L$TERMUX_STANDALONE_TOOLCHAIN/lib/gcc/$TERMUX_HOST_PLATFORM/4.9.x \
		-tools-directory $TERMUX_STANDALONE_TOOLCHAIN/$TERMUX_HOST_PLATFORM/bin \
		-Xlinker -rpath -Xlinker $TERMUX_PREFIX/lib"
		export HOST_SWIFTC="$SWIFT_BINDIR/swiftc"

		# Use the modulemap that points to the sysroot headers in the standalone NDK
		# when cross-compiling, rather than the one meant for running natively on Termux,
		# then install the native modulemap at the end.
		cp $TERMUX_PKG_BUILDDIR/swift-linux-x86_64/lib/swift/android/$TERMUX_ARCH/glibc.modulemap \
			$TERMUX_PREFIX/lib/swift/android/$TERMUX_ARCH/
	fi

	SWIFT_BUILD_ROOT=$TERMUX_PKG_BUILDDIR $TERMUX_PKG_SRCDIR/swift/utils/build-script \
	$SWIFT_TOOLCHAIN_FLAGS $SWIFT_PATH_FLAGS --xctest -b -p --llvm-install-components=IndexStore \
	--install-swift --install-libdispatch --install-foundation --install-xctest \
	--install-llbuild --install-swiftpm $SWIFT_BUILD_FLAGS
}

termux_step_make_install() {
	rm $TERMUX_PREFIX/lib/swift/pm/llbuild/libllbuild.so
	rm $TERMUX_PREFIX/lib/swift/android/lib{dispatch,BlocksRuntime}.so

	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		cp $TERMUX_PKG_BUILDDIR/glibc-native.modulemap \
			$TERMUX_PREFIX/lib/swift/android/$TERMUX_ARCH/glibc.modulemap
	fi
}
