TERMUX_PKG_HOMEPAGE=https://swift.org/
TERMUX_PKG_DESCRIPTION="Swift is a high-performance system programming language"
TERMUX_PKG_LICENSE="Apache-2.0, NCSA"
TERMUX_PKG_MAINTAINER="@buttaface"
TERMUX_PKG_VERSION=5.5.2
SWIFT_RELEASE="RELEASE"
TERMUX_PKG_SRCURL=https://github.com/apple/swift/archive/swift-$TERMUX_PKG_VERSION-$SWIFT_RELEASE.tar.gz
TERMUX_PKG_SHA256=0046ecab640475441251b1cceb3dd167a4c7729852104d7675bdbd75fced6b82
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
SWIFT_TOOLCHAIN_FLAGS="-R --no-assertions --llvm-targets-to-build='X86;ARM;AArch64' -j $TERMUX_MAKE_PROCESSES"
SWIFT_PATH_FLAGS="--build-subdir=. --install-destdir=/ --install-prefix=$TERMUX_PREFIX"
SWIFT_BUILD_FLAGS="$SWIFT_TOOLCHAIN_FLAGS $SWIFT_PATH_FLAGS"

if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
	SWIFT_BIN="swift-$TERMUX_PKG_VERSION-$SWIFT_RELEASE-ubuntu20.04"
	SWIFT_BINDIR="$TERMUX_PKG_HOSTBUILD_DIR/$SWIFT_BIN/usr/bin"
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
	library_checksums[swift-cmark]=90ce146d7e0fda81aa8ecc74fa9401ec9f68596ed6b2c89dbfd0fde11244aa07
	library_checksums[llvm-project]=8e4c58ed8b3518252e8ab96110d2f2e801d7ea1a2e2c176ba55bb13bbd698910
	library_checksums[swift-corelibs-libdispatch]=2611b4dc9530207e19dae07599355622f76c32694aca3ef909149a7ecf48dfc7
	library_checksums[swift-corelibs-foundation]=19e909e006c72813309360d22c3ce13680be5634a0924e78baf10f75fb45f6df
	library_checksums[swift-corelibs-xctest]=24aa1314ac89904d801e5009ebf9e3c1838d40dd22d1f8ab5a34c14b722844aa
	library_checksums[swift-llbuild]=6767df1c14d09c990e72c2e9ec9c61765610c1fe7801c92894afa36f9928d320
	library_checksums[swift-argument-parser]=9dfcb236f599e309e49af145610957648f8a59d9527b4202bc5bdda0068556d7
	library_checksums[Yams]=8bbb28ef994f60afe54668093d652e4d40831c79885fa92b1c2cd0e17e26735a
	library_checksums[swift-crypto]=86d6c22c9f89394fd579e967b0d5d0b6ce33cdbf52ba70f82fa313baf70c759f
	library_checksums[swift-driver]=73416d9b329d88f37d607f0d0a6583368eeec2140a28fb8877ee1fb0125a496e
	library_checksums[swift-tools-support-core]=811ab41295b175d79b940151feacf05fa10787ff250ee3ca8af877041d49d87e
	library_checksums[swift-package-manager]=4c16cb5073759c9bd9de110f96b8fb0983a8255bf28e7b39709876f3bae90e5a
	library_checksums[indexstore-db]=d4d1cb6300a2b5fb81e3e77cba50284ffd6405bc264464db465ee7c2c285807d
	library_checksums[sourcekit-lsp]=ecaeeaddcf750379e561798719290affa6ffd3573754a496d3afa3b3d0f46597

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
			https://swift.org/builds/swift-$TERMUX_PKG_VERSION-release/ubuntu2004/swift-$TERMUX_PKG_VERSION-$SWIFT_RELEASE/$SWIFT_BIN.tar.gz \
			$TERMUX_PKG_CACHEDIR/$SWIFT_BIN.tar.gz \
			383935e857202ff41a411ac11c477d2e86fb8960e186789245991474abf99c9e
	fi
}

termux_step_host_build() {
	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		termux_setup_cmake
		termux_setup_ninja

		local CLANG=$(command -v clang)
		local CLANGXX=$(command -v clang++)

		# The Ubuntu CI may not have clang/clang++ in its path so explicitly set it
		# to clang-10 instead.
		if [ -z "$CLANG" ]; then
			CLANG=$(command -v clang-10)
			CLANGXX=$(command -v clang++-10)
		fi

		# Natively compile llvm-tblgen and some other files needed later.
		SWIFT_BUILD_ROOT=$TERMUX_PKG_HOSTBUILD_DIR $TERMUX_PKG_SRCDIR/swift/utils/build-script \
		-R --no-assertions -j $TERMUX_MAKE_PROCESSES $SWIFT_PATH_FLAGS \
		--skip-build-cmark --skip-build-llvm --skip-build-swift --build-toolchain-only \
		--host-cc=$CLANG --host-cxx=$CLANGXX

		tar xf $TERMUX_PKG_CACHEDIR/$SWIFT_BIN.tar.gz -C $TERMUX_PKG_HOSTBUILD_DIR
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
	# The Swift compiler searches for the clang headers so symlink against them.
	export TERMUX_CLANG_VERSION=$(grep ^TERMUX_PKG_VERSION= $TERMUX_PKG_BUILDER_DIR/../libllvm/build.sh | cut -f2 -d=)

	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		ln -sf $TERMUX_PKG_HOSTBUILD_DIR/llvm-linux-x86_64 $TERMUX_PKG_BUILDDIR/llvm-linux-x86_64
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
		--native-swift-tools-path=$SWIFT_BINDIR
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
