TERMUX_PKG_HOMEPAGE=https://swift.org/
TERMUX_PKG_DESCRIPTION="Swift is a high-performance system programming language"
TERMUX_PKG_LICENSE="Apache-2.0, NCSA"
TERMUX_PKG_MAINTAINER="@buttaface"
TERMUX_PKG_VERSION=5.3.2
SWIFT_RELEASE="RELEASE"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/apple/swift/archive/swift-$TERMUX_PKG_VERSION-$SWIFT_RELEASE.tar.gz
TERMUX_PKG_SHA256=2087bb002dfef7ea2d7fbfaa097eeafd10d997cae52e2f34bb115fca68dd8039
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_DEPENDS="binutils-gold, clang, libc++, ndk-sysroot, libandroid-glob, libandroid-spawn, libcurl, libicu, libicu-static, libsqlite, libuuid, libxml2, libdispatch, llbuild"
TERMUX_PKG_BUILD_DEPENDS="cmake, ninja, perl, pkg-config, python2, rsync"
TERMUX_PKG_BLACKLISTED_ARCHES="i686"
TERMUX_PKG_NO_STATICSPLIT=true

SWIFT_COMPONENTS="autolink-driver;compiler;clang-resource-dir-symlink;swift-remote-mirror;parser-lib;license;sourcekit-inproc;stdlib;sdk-overlay"
SWIFT_TOOLCHAIN_FLAGS="-R --no-assertions --llvm-targets-to-build='X86;ARM;AArch64' -j $TERMUX_MAKE_PROCESSES"
SWIFT_PATH_FLAGS="--build-subdir=. --install-destdir=/ --install-prefix=$TERMUX_PREFIX"
SWIFT_BUILD_FLAGS="$SWIFT_TOOLCHAIN_FLAGS $SWIFT_PATH_FLAGS"

if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
SWIFT_BIN="swift-$TERMUX_PKG_VERSION-$SWIFT_RELEASE-ubuntu20.04"
SWIFT_BINDIR="$TERMUX_PKG_HOSTBUILD_DIR/$SWIFT_BIN/usr/bin"
fi

termux_step_post_get_source() {
	if [ "$TERMUX_PKG_QUICK_REBUILD" = "false" ]; then
		# The Swift build-script requires a particular organization of source directories,
		# which the following sets up.
		mkdir .temp
		mv [a-zA-Z]* .temp/
		mv .temp swift

		declare -A library_checksums
		library_checksums[swift-cmark]=d20bc09a2c76c3fb161886025334cb7e3e9884037ad91d2fa4b42ef36dfee958
		library_checksums[llvm-project]=838e41803613ce4890f4259eef1d99ee4cf1b7cbdf1c664e04e4958863999b38
		library_checksums[swift-corelibs-libdispatch]=d18ad8f24e3461108d8e2e0c838c8fca671f808ab8d06a2c32a7065f321995a1
		library_checksums[swift-corelibs-foundation]=e1bd30e4ad88484b12d7af600c7460bc3495efbf07f243d1ddb543779793a735
		library_checksums[swift-corelibs-xctest]=1f7771c0bc14ce1c6efdc9533c31d063e47af555e1ee6fc5cef42677f96a4131
		library_checksums[swift-llbuild]=296cee1a19c17375877d88084e20e5d98bcc7a87950f3ade143c0222439f1c9d
		library_checksums[swift-package-manager]=e62bbe51d90a93ad52b668e7a882c6a6488782b7e2a5cd74737c177882ebd681

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
				dc360633c85ba16371646da55bcea9f4cf442e3312af2d3f5bb6e85f88d00f7c
		fi
	fi
	# The Swift compiler searches for the clang headers so symlink against them.
	export TERMUX_CLANG_VERSION=$(grep ^TERMUX_PKG_VERSION= $TERMUX_PKG_BUILDER_DIR/../libllvm/build.sh | cut -f2 -d=)
}

termux_step_host_build() {
	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		termux_setup_cmake
		termux_setup_ninja
		termux_setup_standalone_toolchain

		# Natively compile llvm-tblgen and some other files needed later.
		SWIFT_BUILD_ROOT=$TERMUX_PKG_BUILDDIR $TERMUX_PKG_SRCDIR/swift/utils/build-script \
		-R --no-assertions -j $TERMUX_MAKE_PROCESSES $SWIFT_PATH_FLAGS \
		--skip-build-cmark --skip-build-llvm --skip-build-swift \
		--host-cc=$TERMUX_STANDALONE_TOOLCHAIN/bin/clang \
		--host-cxx=$TERMUX_STANDALONE_TOOLCHAIN/bin/clang++

		tar xf $TERMUX_PKG_CACHEDIR/$SWIFT_BIN.tar.gz -C $TERMUX_PKG_HOSTBUILD_DIR
	fi
}

termux_step_pre_configure() {
	export SWIFT_ARCH=$TERMUX_ARCH
	test $SWIFT_ARCH == 'arm' && SWIFT_ARCH='armv7'
	if [ "$TERMUX_PKG_QUICK_REBUILD" = "false" ]; then
		cd llbuild
		# A single patch needed from the existing llbuild package
		patch -p1 < $TERMUX_PKG_BUILDER_DIR/../llbuild/lib-llvm-Support-CmakeLists.txt.patch

		cd ../llvm-project
		patch -p1 < $TERMUX_PKG_BUILDER_DIR/../libllvm/clang-lib-Driver-ToolChain.cpp.patch
		patch -p1 < $TERMUX_PKG_BUILDER_DIR/../libllvm/clang-lib-Driver-ToolChains-Linux.cpp.patch
		cd ..

		sed "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" \
		$TERMUX_PKG_BUILDER_DIR/swiftpm-Utilities-bootstrap | \
		sed "s%\@TERMUX_PKG_BUILDDIR\@%${TERMUX_PKG_BUILDDIR}%g" | \
		sed "s%\@SWIFT_ARCH\@%${SWIFT_ARCH}%g" | patch -p1

		if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
			sed "s%\@TERMUX_STANDALONE_TOOLCHAIN\@%${TERMUX_STANDALONE_TOOLCHAIN}%g" \
			$TERMUX_PKG_BUILDER_DIR/swiftpm-android-flags.json | \
			sed "s%\@CCTERMUX_HOST_PLATFORM\@%${CCTERMUX_HOST_PLATFORM}%g" | \
			sed "s%\@TERMUX_HOST_PLATFORM\@%${TERMUX_HOST_PLATFORM}%g" | \
			sed "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" | \
			sed "s%\@SWIFT_ARCH\@%${SWIFT_ARCH}%g" > $TERMUX_PKG_BUILDDIR/swiftpm-android-flags.json
		fi
	fi
}

termux_step_make() {
	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		export TERMUX_SWIFTPM_FLAGS="-target $CCTERMUX_HOST_PLATFORM \
		-sdk $TERMUX_STANDALONE_TOOLCHAIN/sysroot \
		-L$TERMUX_STANDALONE_TOOLCHAIN/lib/gcc/$TERMUX_HOST_PLATFORM/4.9.x \
		-tools-directory $TERMUX_STANDALONE_TOOLCHAIN/$TERMUX_HOST_PLATFORM/bin \
		-Xlinker -rpath -Xlinker $TERMUX_PREFIX/lib"
		export TERMUX_SWIFT_FLAGS="$TERMUX_SWIFTPM_FLAGS -resource-dir \
		$TERMUX_PKG_BUILDDIR/swift-android-$SWIFT_ARCH/lib/swift"
		SWIFT_BUILD_FLAGS="$SWIFT_BUILD_FLAGS --android
		--android-ndk $TERMUX_STANDALONE_TOOLCHAIN --android-arch $SWIFT_ARCH
		--android-api-level $TERMUX_PKG_API_LEVEL --android-icu-uc $TERMUX_PREFIX/lib/libicuuc.so
		--android-icu-uc-include $TERMUX_PREFIX/include/
		--android-icu-i18n $TERMUX_PREFIX/lib/libicui18n.so
		--android-icu-i18n-include $TERMUX_PREFIX/include/
		--android-icu-data $TERMUX_PREFIX/lib/libicudata.so --build-toolchain-only
		--skip-local-build --skip-local-host-install
		--cross-compile-hosts=android-$SWIFT_ARCH --cross-compile-deps-path=$TERMUX_PREFIX
		--native-swift-tools-path=$SWIFT_BINDIR
		--native-clang-tools-path=$TERMUX_STANDALONE_TOOLCHAIN/bin"
	fi

	SWIFT_BUILD_ROOT=$TERMUX_PKG_BUILDDIR $TERMUX_PKG_SRCDIR/swift/utils/build-script \
	$SWIFT_BUILD_FLAGS --xctest -b -p --build-swift-static-stdlib --install-swift \
	--swift-install-components=$SWIFT_COMPONENTS --llvm-install-components=IndexStore \
	--install-libdispatch --install-foundation --install-xctest --install-llbuild \
	--install-swiftpm
}

termux_step_make_install() {
	rm $TERMUX_PREFIX/lib/swift/pm/llbuild/libllbuild.so
	rm $TERMUX_PREFIX/lib/swift/android/lib{dispatch,BlocksRuntime}.so

	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		mv $TERMUX_PREFIX/glibc-native.modulemap \
			$TERMUX_PREFIX/lib/swift/android/$SWIFT_ARCH/glibc.modulemap
	fi
}
