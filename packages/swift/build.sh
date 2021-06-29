TERMUX_PKG_HOMEPAGE=https://swift.org/
TERMUX_PKG_DESCRIPTION="Swift is a high-performance system programming language"
TERMUX_PKG_LICENSE="Apache-2.0, NCSA"
TERMUX_PKG_MAINTAINER="@buttaface"
TERMUX_PKG_VERSION=5.4.2
SWIFT_RELEASE="RELEASE"
TERMUX_PKG_SRCURL=https://github.com/apple/swift/archive/swift-$TERMUX_PKG_VERSION-$SWIFT_RELEASE.tar.gz
TERMUX_PKG_SHA256=df36ef943e0759b602d36d538e0f19db60a1b56b01f6b8bff2564313f665a183
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_DEPENDS="binutils-gold, clang, libc++, ndk-sysroot, libandroid-glob, libandroid-spawn, libcurl, libicu, libicu-static, libsqlite, libuuid, libxml2, libdispatch, llbuild"
TERMUX_PKG_BUILD_DEPENDS="cmake, ninja, perl, pkg-config, rsync"
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
		# The Swift build-script requires a particular organization of source
		# directories, which the following sets up.
		mkdir .temp
		mv [a-zA-Z]* .temp/
		mv .temp swift

		declare -A library_checksums
		library_checksums[swift-cmark]=d1c2d9728667a563e9420c608ef4fcde749a86e38ee373e8b109bce5eb94510d
		library_checksums[llvm-project]=50401b5b696292ccf6dc11f59f34f8958fdc0097c7d4db9cd862a4622ee1676a
		library_checksums[swift-corelibs-libdispatch]=84602423596712a1fd0d866d640af0c2de56c52ea03c95864af900a55945ef37
		library_checksums[swift-corelibs-foundation]=38e15b60188a4240fe71b9ca6e9409d423d342896102ac957db42d7fa8b4ad23
		library_checksums[swift-corelibs-xctest]=5e0bede769b0869e65d2626a3bfdab09faf99dfe48366a37e5c72dc3b7dc9287
		library_checksums[swift-llbuild]=d5562e63fd68f6fcd64c60820a1be0142592a2742c71c1c6fe673f34854ac599
		library_checksums[swift-argument-parser]=6743338612be50a5a32127df0a3dd1c34e695f5071b1213f128e6e2b27c4364a
		library_checksums[Yams]=8bbb28ef994f60afe54668093d652e4d40831c79885fa92b1c2cd0e17e26735a
		library_checksums[swift-driver]=9907e6d41236cf543a43a89b5ff67b6cb12474692f96069908d4b6f92b617518
		library_checksums[swift-tools-support-core]=a4bc991cf601fe0f45edc7d0a6248f1a19def4d149b3e86b37361f34b0ecbd2c
		library_checksums[swift-package-manager]=3648d7cbf74a2ad69b444d78b53e278541b1bd0e4e54fb1b8bc9002596bbaf4b

		for library in "${!library_checksums[@]}"; do \
			if [ "$library" = "swift-argument-parser" ]; then
				GH_ORG="apple"
				SRC_VERSION="0.4.1"
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
				86b849d9f6ba2eda4e12ea5eafaa0748bffcd6272466b514c2b0fd4a829c63a4
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
		--skip-build-cmark --skip-build-llvm --skip-build-swift --build-toolchain-only \
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
		sed "s%\@TERMUX_PKG_BUILDDIR\@%${TERMUX_PKG_BUILDDIR}%g" | patch -p1

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
		SWIFT_BUILD_FLAGS="$SWIFT_BUILD_FLAGS --android
		--android-ndk $TERMUX_STANDALONE_TOOLCHAIN --android-arch $SWIFT_ARCH
		--android-icu-uc $TERMUX_PREFIX/lib/libicuuc.so
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
	$SWIFT_BUILD_FLAGS --xctest -b -p --android-api-level $TERMUX_PKG_API_LEVEL \
	--build-swift-static-stdlib --swift-install-components=$SWIFT_COMPONENTS \
	--llvm-install-components=IndexStore --install-llvm --install-swift \
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
