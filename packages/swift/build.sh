TERMUX_PKG_HOMEPAGE=https://www.swift.org/
TERMUX_PKG_DESCRIPTION="Swift is a high-performance system programming language"
TERMUX_PKG_LICENSE="Apache-2.0, NCSA"
TERMUX_PKG_VERSION=5.2.1
TERMUX_PKG_REVISION=2
SWIFT_RELEASE="RELEASE"
TERMUX_PKG_SHA256=3488e920ad989b1c6a8d25ef241d356a9951184fefcad19e230e3263b6e80f48
TERMUX_PKG_SRCURL=https://github.com/apple/swift/archive/swift-$TERMUX_PKG_VERSION-$SWIFT_RELEASE.tar.gz
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_DEPENDS="binutils-gold, libc++, ndk-sysroot, libandroid-glob, libandroid-spawn, libcurl, libicu, libsqlite, libuuid, libxml2, libdispatch, llbuild"
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
				3f7522163fc6999560ade1ac80ceac8d1f6eb9b050511cb81c53d41e9ac9a180
		fi

		declare -A library_checksums
		library_checksums[swift-cmark]=ac18a4a55739af8afb9009f4d8d7643a78fda47a329e1b1f8c782122db88b3b1
		library_checksums[llvm-project]=f21cfa75413ab290991f28a05a975b15af9289140e2f595aa981e630496907e7
		library_checksums[swift-corelibs-libdispatch]=7bab5d4d1e8e0aea0d7fec80b1dbf7f897389d19566e02ef5cd0e7026b968f10
		library_checksums[swift-corelibs-foundation]=5a223f6398d5cedb94019f61beca69eb35473ca2cc65bcbd60d93248342f417d
		library_checksums[swift-corelibs-xctest]=d25df8b4caaef8e8339ecb2344fd5cbbe10b2e0f33d9861b1ec8fdebf7364645
		library_checksums[swift-llbuild]=8812862ef27079fb41f13ac3e741a1e488bd321d79c6a57d026ca1c1e25d90c7
		library_checksums[swift-package-manager]=73e12edffce218d1fdfd626c2000a9d9f5805a946175899600b50379e885770e

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
		export PATH=$TERMUX_PKG_BUILDDIR:$PATH
	fi
}

termux_step_host_build() {
	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		tar xf $TERMUX_PKG_CACHEDIR/swift-$TERMUX_PKG_VERSION-$SWIFT_RELEASE-ubuntu18.04.tar.gz
		local SWIFT_BINDIR="$TERMUX_PKG_HOSTBUILD_DIR/swift-$TERMUX_PKG_VERSION-$SWIFT_RELEASE-ubuntu18.04/usr/bin"

		termux_setup_cmake
		termux_setup_ninja
		termux_setup_standalone_toolchain

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
		--host-cc=/usr/bin/clang-9 --host-cxx=/usr/bin/clang++-9
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
