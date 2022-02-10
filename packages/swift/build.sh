TERMUX_PKG_HOMEPAGE=https://swift.org/
TERMUX_PKG_DESCRIPTION="Swift is a high-performance system programming language"
TERMUX_PKG_LICENSE="Apache-2.0, NCSA"
TERMUX_PKG_MAINTAINER="@buttaface"
TERMUX_PKG_VERSION=5.5.3
SWIFT_RELEASE="RELEASE"
TERMUX_PKG_SRCURL=https://github.com/apple/swift/archive/swift-$TERMUX_PKG_VERSION-$SWIFT_RELEASE.tar.gz
TERMUX_PKG_SHA256=41c926ae261a2756fe5ff761927aafe297105dc62f676a27c3da477f13251888
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_DEPENDS="clang, libandroid-glob, libandroid-spawn, libcurl, libicu, libicu-static, libsqlite, libuuid, libxml2, libdispatch, llbuild"
TERMUX_PKG_BUILD_DEPENDS="cmake, ninja, perl, pkg-config, rsync"
TERMUX_PKG_BLACKLISTED_ARCHES="i686"
TERMUX_PKG_NO_STATICSPLIT=true
# Build of swift uses cmake, but the standard
# termux_step_configure_cmake function is not used. Instead we set
# TERMUX_PKG_FORCE_CMAKE to make the build system aware that cmake is
# needed.
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_CMAKE_BUILD=Ninja

SWIFT_COMPONENTS="autolink-driver;compiler;clang-resource-dir-symlink;swift-remote-mirror;parser-lib;license;sourcekit-inproc;stdlib;sdk-overlay"
SWIFT_TOOLCHAIN_FLAGS="-RA --llvm-targets-to-build='X86;ARM;AArch64' -j $TERMUX_MAKE_PROCESSES"
SWIFT_PATH_FLAGS="--build-subdir=. --install-destdir=/ --install-prefix=$TERMUX_PREFIX"
SWIFT_BUILD_FLAGS="$SWIFT_TOOLCHAIN_FLAGS $SWIFT_PATH_FLAGS"

if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
	SWIFT_BIN="swift-$TERMUX_PKG_VERSION-$SWIFT_RELEASE-ubuntu20.04"
	export SWIFT_BINDIR="$TERMUX_PKG_HOSTBUILD_DIR/$SWIFT_BIN/usr/bin"
fi
SWIFT_ARCH=$TERMUX_ARCH
test $SWIFT_ARCH == 'arm' && SWIFT_ARCH='armv7'

termux_step_post_get_source() {
	# The Swift build-script requires a particular organization of source
	# directories, which the following sets up.
	mkdir .temp
	mv [a-zA-Z]* .temp/
	mv .temp swift

	declare -A library_checksums
	library_checksums[swift-cmark]=f00df80d917cf6b3e1870a75f7b29bc7ac8b94479c0961167359e4156dcd1220
	library_checksums[llvm-project]=d28f71363f6ae5fec59ec3c21e53ab91e3a196c833150329397888259765098b
	library_checksums[swift-corelibs-libdispatch]=dc0912c2812953c84eea996358abd6a2dbeb97f334d5c1d4064e077ca43d569f
	library_checksums[swift-corelibs-foundation]=aa11982d45f1eb238547be30c1b34409b08ee2de35fcf3a4981992d21839d0fc
	library_checksums[swift-corelibs-xctest]=2c08d83a9c051329cadb248dd0dd5cddfe582f00bc1d569dc8dc59433c4906f3
	library_checksums[swift-llbuild]=8444b840137f17d465e4080f8437b6b5fe68a01a095b4976e8e3e2f1a629b96a
	library_checksums[swift-argument-parser]=9dfcb236f599e309e49af145610957648f8a59d9527b4202bc5bdda0068556d7
	library_checksums[Yams]=8bbb28ef994f60afe54668093d652e4d40831c79885fa92b1c2cd0e17e26735a
	library_checksums[swift-crypto]=86d6c22c9f89394fd579e967b0d5d0b6ce33cdbf52ba70f82fa313baf70c759f
	library_checksums[swift-driver]=47d04b5120eaf508e73ed658b0564fab2fccb9313ef5180afc84d3040c31ccfc
	library_checksums[swift-tools-support-core]=bf82f281d1c47a8f7762c0b01f2d772726a9da71fdd867b031e52bd15967504c
	library_checksums[swift-package-manager]=6e46827b118f5449cf7c32b7c9eb6060829ff09a94c2278dd4253f7e56a35cac
	library_checksums[indexstore-db]=b7c0f46f944e90e1ffa298b96f4cfc5ddeebf67d0935edee9858e0dfe8e30db6
	library_checksums[sourcekit-lsp]=ef956db48fa2e80eefabdc4bfb68433b9e8555c6e39ec6b48a9b5b5628d8d5e4

	for library in "${!library_checksums[@]}"; do \
		if [ "$library" = "swift-argument-parser" ]; then
			GH_ORG="apple"
			SRC_VERSION="0.4.3"
			TAR_NAME=$SRC_VERSION
		elif [ "$library" = "swift-crypto" ]; then
			GH_ORG="apple"
			SRC_VERSION="1.1.5"
			TAR_NAME=$SRC_VERSION
		elif [ "$library" = "Yams" ]; then
			GH_ORG="jpsim"
			SRC_VERSION="4.0.2"
			TAR_NAME=$SRC_VERSION
		else
			GH_ORG="apple"
			SRC_VERSION=$SWIFT_RELEASE
			TAR_NAME=swift-$TERMUX_PKG_VERSION-$SWIFT_RELEASE
		fi

		termux_download \
			https://github.com/$GH_ORG/$library/archive/$TAR_NAME.tar.gz \
			$TERMUX_PKG_CACHEDIR/$library-$SRC_VERSION.tar.gz \
			${library_checksums[$library]}
		tar xf $TERMUX_PKG_CACHEDIR/$library-$SRC_VERSION.tar.gz
		mv $library-$TAR_NAME $library
	done

	mv swift-cmark cmark
	mv swift-llbuild llbuild
	mv Yams yams
	mv swift-package-manager swiftpm

	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		termux_download \
			https://download.swift.org/swift-$TERMUX_PKG_VERSION-release/ubuntu2004/swift-$TERMUX_PKG_VERSION-$SWIFT_RELEASE/$SWIFT_BIN.tar.gz \
			$TERMUX_PKG_CACHEDIR/$SWIFT_BIN.tar.gz \
			68c69d7978ff90332580c5de489aff96df84bc0cf67d94ecef41f6848f68db91
	fi
}

termux_step_host_build() {
	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		termux_setup_cmake
		termux_setup_ninja

		local CLANG=$(command -v clang)
		local CLANGXX=$(command -v clang++)

		# The Ubuntu CI may not have clang/clang++ in its path so explicitly set it
		# to clang-12 instead.
		if [ -z "$CLANG" ]; then
			CLANG=$(command -v clang-12)
			CLANGXX=$(command -v clang++-12)
		fi

		local SKIP_BUILD="--skip-build-compiler-rt"
		test $TERMUX_ARCH != 'aarch64' && SKIP_BUILD="--skip-build-cmark --skip-build-llvm --skip-build-swift"

		# Natively compile llvm-tblgen and some other files needed later.
		SWIFT_BUILD_ROOT=$TERMUX_PKG_HOSTBUILD_DIR $TERMUX_PKG_SRCDIR/swift/utils/build-script \
		-R --no-assertions -j $TERMUX_MAKE_PROCESSES $SWIFT_PATH_FLAGS \
		$SKIP_BUILD --build-toolchain-only \
		--host-cc=$CLANG --host-cxx=$CLANGXX

		tar xf $TERMUX_PKG_CACHEDIR/$SWIFT_BIN.tar.gz -C $TERMUX_PKG_HOSTBUILD_DIR
		if [ "$TERMUX_ARCH" == "aarch64" ]; then
			rm $TERMUX_PKG_HOSTBUILD_DIR/swift-linux-x86_64/lib/swift/FrameworkABIBaseline
			cp -r $SWIFT_BIN/usr/lib/swift $TERMUX_PKG_HOSTBUILD_DIR/swift-linux-x86_64/lib
			ln -sf $SWIFT_BINDIR/../lib/clang/10.0.0 $TERMUX_PKG_HOSTBUILD_DIR/swift-linux-x86_64/lib/swift/clang
			patchelf --set-rpath \$ORIGIN $TERMUX_PKG_HOSTBUILD_DIR/swift-linux-x86_64/lib/swift/linux/libicu{uc,i18n}swift.so.65.1
		fi
	fi
}

termux_step_pre_configure() {
	cd llbuild
	# A single patch needed from the existing llbuild package
	patch -p1 < $TERMUX_PKG_BUILDER_DIR/../llbuild/lib-llvm-Support-CmakeLists.txt.patch

	cd ../llvm-project
	patch -p1 < $TERMUX_PKG_BUILDER_DIR/../libllvm/clang-lib-Driver-ToolChain.cpp.patch
	patch -p1 < $TERMUX_PKG_BUILDER_DIR/clang-lib-Driver-ToolChains-Linux.cpp.diff
	cd ../swift-corelibs-libdispatch
	patch -p1 < $TERMUX_PKG_BUILDER_DIR/../libdispatch/src-shims-atomic.h.patch
	cd ..

	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		sed "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" \
		$TERMUX_PKG_BUILDER_DIR/swiftpm-driver-lsp-termux-flags | \
		sed "s%\@CCTERMUX_HOST_PLATFORM\@%${CCTERMUX_HOST_PLATFORM}%g" | patch -p1
	fi
}

termux_step_make() {
	# The Swift compiler searches for the clang headers, so symlink against them using their version.
	export TERMUX_CLANG_VERSION=$(grep ^TERMUX_PKG_VERSION= $TERMUX_PKG_BUILDER_DIR/../libllvm/build.sh | cut -f2 -d=)

	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		ln -sf $TERMUX_PKG_HOSTBUILD_DIR/llvm-linux-x86_64 $TERMUX_PKG_BUILDDIR/llvm-linux-x86_64

		local SWIFT_TOOLCHAIN=
		if [ "$SWIFT_ARCH" = "aarch64" ]; then
			ln -sf $TERMUX_PKG_HOSTBUILD_DIR/swift-linux-x86_64 $TERMUX_PKG_BUILDDIR/swift-linux-x86_64
		else
			SWIFT_TOOLCHAIN="--native-swift-tools-path=$SWIFT_BINDIR"
		fi

		SWIFT_BUILD_FLAGS="$SWIFT_BUILD_FLAGS --android
		--android-ndk $TERMUX_STANDALONE_TOOLCHAIN --android-arch $SWIFT_ARCH
		--android-icu-uc $TERMUX_PREFIX/lib/libicuuc.so
		--android-icu-uc-include $TERMUX_PREFIX/include/
		--android-icu-i18n $TERMUX_PREFIX/lib/libicui18n.so
		--android-icu-i18n-include $TERMUX_PREFIX/include/
		--android-icu-data $TERMUX_PREFIX/lib/libicudata.so --build-toolchain-only
		--skip-local-build --skip-local-host-install
		--cross-compile-hosts=android-$SWIFT_ARCH
		--cross-compile-deps-path=$(dirname $TERMUX_PREFIX)
		$SWIFT_TOOLCHAIN
		--native-clang-tools-path=$SWIFT_BINDIR"
	fi

	SWIFT_BUILD_ROOT=$TERMUX_PKG_BUILDDIR $TERMUX_PKG_SRCDIR/swift/utils/build-script \
	$SWIFT_BUILD_FLAGS --xctest -b -p --swift-driver --sourcekit-lsp \
	--android-api-level $TERMUX_PKG_API_LEVEL \
	--build-swift-static-stdlib --swift-install-components=$SWIFT_COMPONENTS \
	--llvm-install-components=IndexStore --install-llvm --install-swift \
	--install-libdispatch --install-foundation --install-xctest --install-llbuild \
	--install-swiftpm --install-swift-driver --install-sourcekit-lsp
}

termux_step_make_install() {
	rm $TERMUX_PREFIX/lib/swift/pm/llbuild/libllbuild.so
	rm $TERMUX_PREFIX/lib/swift/android/lib{dispatch,BlocksRuntime}.so

	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		rm $TERMUX_PREFIX/swiftpm-android-$SWIFT_ARCH.json
		mv $TERMUX_PREFIX/glibc-native.modulemap \
			$TERMUX_PREFIX/lib/swift/android/$SWIFT_ARCH/glibc.modulemap
	fi
}
