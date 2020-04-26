TERMUX_PKG_HOMEPAGE=https://www.swift.org/
TERMUX_PKG_DESCRIPTION="Swift is a high-performance system programming language"
TERMUX_PKG_LICENSE="Apache-2.0, NCSA"
TERMUX_PKG_VERSION=5.2.2
TERMUX_PKG_REVISION=1
SWIFT_RELEASE="RELEASE"
TERMUX_PKG_SHA256=92b0d1225e61a521ea10fe25f2cc35a2ad50ac55d1690d710f675d4db0c13b35
TERMUX_PKG_SRCURL=https://github.com/apple/swift/archive/swift-$TERMUX_PKG_VERSION-$SWIFT_RELEASE.tar.gz
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_DEPENDS="binutils-gold, libc++, ndk-sysroot, libandroid-glob, libandroid-spawn, libcurl, libicu, libicu-static, libsqlite, libuuid, libxml2, libdispatch, llbuild"
TERMUX_PKG_BUILD_DEPENDS="cmake, ninja, perl, pkg-config, python2, rsync"
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686, x86_64"
TERMUX_PKG_NO_STATICSPLIT=true

SWIFT_COMPONENTS="autolink-driver;compiler;clang-resource-dir-symlink;swift-remote-mirror;parser-lib;license;sourcekit-inproc"
SWIFT_TOOLCHAIN_FLAGS="-R --no-assertions --llvm-targets-to-build='X86;ARM;AArch64' -j $TERMUX_MAKE_PROCESSES"
SWIFT_PATH_FLAGS="--build-subdir=. --install-destdir=/ --install-prefix=$TERMUX_PREFIX"

if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
SWIFT_ANDROID_NDK_FLAGS="--android --android-ndk $TERMUX_STANDALONE_TOOLCHAIN --android-arch $TERMUX_ARCH
--android-api-level $TERMUX_PKG_API_LEVEL --android-icu-uc $TERMUX_PREFIX/lib/libicuuc.so
--android-icu-uc-include $TERMUX_PREFIX/include/ --android-icu-i18n $TERMUX_PREFIX/lib/libicui18n.so
--android-icu-i18n-include $TERMUX_PREFIX/include/ --android-icu-data $TERMUX_PREFIX/lib/libicudata.so"
fi

termux_step_post_extract_package() {
	if [ "$TERMUX_PKG_QUICK_REBUILD" = "false" ]; then
		# The Swift build-script requires a particular organization of source directories,
		# which the following sets up.
		mkdir .temp
		mv [a-zA-Z]* .temp/
		mv .temp swift

		if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
			termux_download \
				https://swift.org/builds/swift-$TERMUX_PKG_VERSION-release/ubuntu1804/swift-$TERMUX_PKG_VERSION-$SWIFT_RELEASE/swift-$TERMUX_PKG_VERSION-$SWIFT_RELEASE-ubuntu18.04.tar.gz \
				$TERMUX_PKG_CACHEDIR/swift-$TERMUX_PKG_VERSION-$SWIFT_RELEASE-ubuntu18.04.tar.gz \
				c29afff6ebf3ca69a9b5a5621b9ffd7614626070eb982d4e7174a6d8352b6ce2
		fi

		declare -A library_checksums
		library_checksums[swift-cmark]=0992aa8065beb88c8471e30e414a243be3e270b02b66e4c242ba741169baafe4
		library_checksums[llvm-project]=2c30e793e4bc29dc396fab522bebda731bb25be0019b07f314e70139c94de552
		library_checksums[swift-corelibs-libdispatch]=cae4ffc25cc3e349f63292cace22d922d81ac7f82f29d9ceac8c9210d04e662d
		library_checksums[swift-corelibs-foundation]=e27590541c326e1f7a254070f87f0871b6593a6b206a8ef9be5c9af22c3d2e15
		library_checksums[swift-corelibs-xctest]=5f93884c542552602d3a6bb2acd087aa5400bca68d9be79b4b1afd51fb8ca982
		library_checksums[swift-llbuild]=b54ec43c58bf2fddfcc4e83fe744567f05274feb024dd2a39dba6b1badb49fac
		library_checksums[swift-package-manager]=6d259436b1c09512e285187eb8794bbf550bdb513e243bc46e4790df0b1b9be8

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

		# The Swift compiler searches for the clang headers so symlink against them.
		local TERMUX_CLANG_VERSION=$(grep ^TERMUX_PKG_VERSION= $TERMUX_PKG_BUILDER_DIR/../libllvm/build.sh | cut -f2 -d=)
		sed "s%\@TERMUX_CLANG_VERSION\@%${TERMUX_CLANG_VERSION}%g" $TERMUX_PKG_BUILDER_DIR/swift-stdlib-public-SwiftShims-CMakeLists.txt | \
			patch -p1

		# The Swift package manager has to be pointed at the Termux prefix.
		local TERMUX_APP_PREFIX=$(dirname $TERMUX_PREFIX)
		sed "s%\@TERMUX_APP_PREFIX\@%${TERMUX_APP_PREFIX}%g" $TERMUX_PKG_BUILDER_DIR/swiftpm-Sources-Workspace-Destination.swift | \
			patch -p1

		# The Swift build scripts still depend on Python 2, so make sure it's used.
		ln -s $(which python2) $TERMUX_PKG_BUILDDIR/python
	fi
	export PATH=$TERMUX_PKG_BUILDDIR:$PATH
}

termux_step_host_build() {
	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		if [ "$TERMUX_PKG_QUICK_REBUILD" = "false" ]; then
			tar xf $TERMUX_PKG_CACHEDIR/swift-$TERMUX_PKG_VERSION-$SWIFT_RELEASE-ubuntu18.04.tar.gz
		fi
		local SWIFT_BINDIR="$TERMUX_PKG_HOSTBUILD_DIR/swift-$TERMUX_PKG_VERSION-$SWIFT_RELEASE-ubuntu18.04/usr/bin"

		termux_setup_cmake
		termux_setup_ninja
		termux_setup_standalone_toolchain

		local CLANG=$(command -v clang)
		local CLANGXX=$(command -v clang++)

		# The Ubuntu CI may not have clang/clang++ in its path so explicitly set it
		# to clang-9 instead.
		if [ -z "$CLANG" ]; then
			CLANG=$(command -v clang-9)
			CLANGXX=$(command -v clang++-9)
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
	fi
}

termux_step_pre_configure() {
	if [ "$TERMUX_PKG_QUICK_REBUILD" = "false" ]; then
		cd llbuild
		# A single patch needed from the existing llbuild package
		patch -p1 < $TERMUX_PKG_BUILDER_DIR/../llbuild/lib-llvm-Support-CmakeLists.txt.patch

		if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
			cd ..
			# Build patch needed only when cross-compiling the compiler.
			sed "s%\@TERMUX_STANDALONE_TOOLCHAIN\@%${TERMUX_STANDALONE_TOOLCHAIN}%g" \
			$TERMUX_PKG_BUILDER_DIR/swift-utils-build-script-impl | \
			sed "s%\@TERMUX_PKG_API_LEVEL\@%${TERMUX_PKG_API_LEVEL}%g" | \
			sed "s%\@TERMUX_ARCH\@%${TERMUX_ARCH}%g" | patch -p1
		fi
	fi
}

termux_step_make() {
	if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ]; then
		SWIFT_BUILD_ROOT=$TERMUX_PKG_BUILDDIR $TERMUX_PKG_SRCDIR/swift/utils/build-script \
		$SWIFT_TOOLCHAIN_FLAGS $SWIFT_PATH_FLAGS --xctest -b -p --build-swift-static-stdlib \
		--build-swift-static-sdk-overlay --llvm-install-components=IndexStore \
		--install-swift --swift-install-components="$SWIFT_COMPONENTS;stdlib;sdk-overlay" \
		--install-libdispatch --install-foundation --install-xctest --install-swiftpm
	else
		SWIFT_BUILD_ROOT=$TERMUX_PKG_BUILDDIR $TERMUX_PKG_SRCDIR/swift/utils/build-script \
		$SWIFT_TOOLCHAIN_FLAGS $SWIFT_ANDROID_NDK_FLAGS $SWIFT_PATH_FLAGS \
		--build-toolchain-only --cross-compile-hosts=android-$TERMUX_ARCH \
		--build-swift-dynamic-stdlib=0 --build-swift-dynamic-sdk-overlay=0 \
		--llvm-install-components=IndexStore --swift-install-components="$SWIFT_COMPONENTS" \
		--install-swift
	fi
}

termux_step_make_install() {
	if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ]; then
		mkdir -p $TERMUX_PREFIX/lib/swift/pm/llbuild
		cp llbuild-android-$TERMUX_ARCH/lib/libllbuildSwift.so $TERMUX_PREFIX/lib/swift/pm/llbuild
	fi
}
