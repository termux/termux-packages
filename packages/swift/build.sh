TERMUX_PKG_HOMEPAGE=https://swift.org/
TERMUX_PKG_DESCRIPTION="Swift is a high-performance system programming language"
TERMUX_PKG_LICENSE="Apache-2.0, NCSA"
TERMUX_PKG_VERSION=5.2.4
TERMUX_PKG_REVISION=3
SWIFT_RELEASE="RELEASE"
TERMUX_PKG_SRCURL=https://github.com/apple/swift/archive/swift-$TERMUX_PKG_VERSION-$SWIFT_RELEASE.tar.gz
TERMUX_PKG_SHA256=94c44101c3dd6774887029110269bbaf9aff68cce5ea0783588157cc08d82ed8
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
SWIFT_ANDROID_NDK_FLAGS="--android --android-ndk $TERMUX_STANDALONE_TOOLCHAIN --android-arch $TERMUX_ARCH
--android-api-level $TERMUX_PKG_API_LEVEL --android-icu-uc $TERMUX_PREFIX/lib/libicuuc.so
--android-icu-uc-include $TERMUX_PREFIX/include/ --android-icu-i18n $TERMUX_PREFIX/lib/libicui18n.so
--android-icu-i18n-include $TERMUX_PREFIX/include/ --android-icu-data $TERMUX_PREFIX/lib/libicudata.so"
SWIFT_BUILD_FLAGS="$SWIFT_ANDROID_NDK_FLAGS --build-toolchain-only
--cross-compile-hosts=android-$TERMUX_ARCH --swift-install-components='$SWIFT_COMPONENTS'
--build-swift-dynamic-stdlib=0 --build-swift-dynamic-sdk-overlay=0"
fi

termux_step_post_get_source() {
	if [ "$TERMUX_PKG_QUICK_REBUILD" = "false" ]; then
		# The Swift build-script requires a particular organization of source directories,
		# which the following sets up.
		mkdir .temp
		mv [a-zA-Z]* .temp/
		mv .temp swift

		declare -A library_checksums
		library_checksums[swift-cmark]=d5f656777961390987ed04de2120e73e032713bbd7b616b5e43eb3ae6e209cb5
		library_checksums[llvm-project]=e36edc6c19e013a81b9255e329e9d6ffe7dfd89e8f8f23e1d931464c5f717d3a
		library_checksums[swift-corelibs-libdispatch]=fa81aa11b490643b95b472d0c01b01fd6a8a1b286fece6e8128ab78e764e9eaa
		library_checksums[swift-corelibs-foundation]=b917634ec51fc670ba42121e77c159d1eb412d1384a18acc12a857a075d89cfb
		library_checksums[swift-corelibs-xctest]=e41e685a854ad15c98035d0a3608dfcce219c95d73df6144f4d9b3dbe3ca1454
		library_checksums[swift-llbuild]=66b5374a15998a80cd72e7c1312766a8cbfe427a850f7b97d39b5d0508306e6c
		library_checksums[swift-package-manager]=383bf75f6dea96c4d48b2242bd3116154365e0e032aa3dce968f2c434732446c

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
				https://swift.org/builds/swift-$TERMUX_PKG_VERSION-release/ubuntu2004/swift-$TERMUX_PKG_VERSION-$SWIFT_RELEASE/swift-$TERMUX_PKG_VERSION-$SWIFT_RELEASE-ubuntu20.04.tar.gz \
				$TERMUX_PKG_CACHEDIR/swift-$TERMUX_PKG_VERSION-$SWIFT_RELEASE-ubuntu20.04.tar.gz \
				00629cde8f10b0a97646cb89f7ee66ad1e65f259d25d7e03132e348dcf4d792b
		fi

		# The Swift compiler searches for the clang headers so symlink against them.
		export TERMUX_CLANG_VERSION=$(grep ^TERMUX_PKG_VERSION= $TERMUX_PKG_BUILDER_DIR/../libllvm/build.sh | cut -f2 -d=)
		sed "s%\@TERMUX_CLANG_VERSION\@%${TERMUX_CLANG_VERSION}%g" $TERMUX_PKG_BUILDER_DIR/swift-stdlib-public-SwiftShims-CMakeLists.txt | \
			patch -p1

		# The Swift package manager has to be pointed at the Termux prefix.
		local TERMUX_APP_PREFIX=$(dirname $TERMUX_PREFIX)
		sed "s%\@TERMUX_APP_PREFIX\@%${TERMUX_APP_PREFIX}%g" $TERMUX_PKG_BUILDER_DIR/swiftpm-Sources-Workspace-Destination.swift | \
			patch -p1

		# The Swift build scripts still depend on Python 2, so make sure it's used.
		ln -s $(command -v python2) $TERMUX_PKG_BUILDDIR/python
	fi
	export PATH=$TERMUX_PKG_BUILDDIR:$PATH
}

termux_step_host_build() {
	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		if [ "$TERMUX_PKG_QUICK_REBUILD" = "false" ]; then
			tar xf $TERMUX_PKG_CACHEDIR/swift-$TERMUX_PKG_VERSION-$SWIFT_RELEASE-ubuntu20.04.tar.gz
		fi
		local SWIFT_BINDIR="$TERMUX_PKG_HOSTBUILD_DIR/swift-$TERMUX_PKG_VERSION-$SWIFT_RELEASE-ubuntu20.04/usr/bin"

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

		if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
			# Build patch needed only when cross-compiling the compiler.
			sed "s%\@TERMUX_STANDALONE_TOOLCHAIN\@%${TERMUX_STANDALONE_TOOLCHAIN}%g" \
			$TERMUX_PKG_BUILDER_DIR/swift-utils-build-script-impl | \
			sed "s%\@TERMUX_PKG_API_LEVEL\@%${TERMUX_PKG_API_LEVEL}%g" | \
			sed "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" | \
			sed "s%\@TERMUX_ARCH\@%${TERMUX_ARCH}%g" | patch -p1
		fi

		sed "s%\@TERMUX_STANDALONE_TOOLCHAIN\@%${TERMUX_STANDALONE_TOOLCHAIN}%g" \
		$TERMUX_PKG_BUILDER_DIR/swiftpm-Utilities-bootstrap | \
		sed "s%\@TERMUX_PKG_API_LEVEL\@%${TERMUX_PKG_API_LEVEL}%g" | \
		sed "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" | \
		sed "s%\@TERMUX_ARCH\@%${TERMUX_ARCH}%g" | patch -p1
	fi
}

termux_step_make() {
	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		export TERMUX_SWIFT_FLAGS="-target $CCTERMUX_HOST_PLATFORM \
		-resource-dir $TERMUX_PREFIX/lib/swift -sdk $TERMUX_STANDALONE_TOOLCHAIN/sysroot \
		-L$TERMUX_STANDALONE_TOOLCHAIN/lib/gcc/$TERMUX_HOST_PLATFORM/4.9.x \
		-tools-directory $TERMUX_STANDALONE_TOOLCHAIN/$TERMUX_HOST_PLATFORM/bin \
		-Xlinker -rpath -Xlinker $TERMUX_PREFIX/lib"
		export HOST_SWIFTC="$TERMUX_PKG_HOSTBUILD_DIR/swift-$TERMUX_PKG_VERSION-$SWIFT_RELEASE-ubuntu20.04/usr/bin/swiftc"

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

	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		cp $TERMUX_PKG_BUILDDIR/glibc-native.modulemap \
			$TERMUX_PREFIX/lib/swift/android/$TERMUX_ARCH/glibc.modulemap
		cp $TERMUX_PKG_BUILDDIR/swiftpm-android-$TERMUX_ARCH/linux-android/tsc/lib/libTSC{Basic,Libc,Utility}.so \
			$TERMUX_PREFIX/lib/swift/pm/

		for PMlib in Build PackageGraph SPMLLBuild Xcodeproj Commands PackageLoading SourceControl LLBuildManifest PackageModel Workspace; do
			cp $TERMUX_PKG_BUILDDIR/swiftpm-android-$TERMUX_ARCH/linux-android/bootstrap/lib/lib$PMlib.so \
				$TERMUX_PREFIX/lib/swift/pm/
		done
	fi
}
