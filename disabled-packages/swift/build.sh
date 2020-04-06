TERMUX_PKG_HOMEPAGE=https://www.swift.org/
TERMUX_PKG_DESCRIPTION="Swift is a high-performance system programming language"
TERMUX_PKG_LICENSE="Apache-2.0, NCSA"
TERMUX_PKG_VERSION=5.1.4
TERMUX_PKG_SHA256=46765a6a604be0b11cb4660bf5adbef8a95d2b74b03aa46860ef81a5ba92d5e8
TERMUX_PKG_SRCURL=https://github.com/apple/swift/archive/swift-$TERMUX_PKG_VERSION-RELEASE.tar.gz
TERMUX_PKG_DEPENDS="binutils-gold, libc++, ndk-sysroot, libandroid-spawn, libcurl, libicu, libsqlite, libuuid, libxml2, llbuild"
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686, x86_64"
TERMUX_PKG_NO_STATICSPLIT=true

SWIFT_BUILD_PACKAGES="cmake, ninja, perl, pkg-config, python2, rsync"
SWIFT_COMPONENTS="autolink-driver;compiler;clang-builtin-headers;stdlib;swift-remote-mirror;sdk-overlay;parser-lib;toolchain-tools;license;sourcekit-inproc"
SWIFT_BUILD_FLAGS="-R --no-assertions --llvm-targets-to-build='X86;ARM;AArch64'
	--xctest -b -p -j $TERMUX_MAKE_PROCESSES --build-subdir=. --install-destdir=/
	--install-prefix=$TERMUX_PREFIX --swift-install-components='$SWIFT_COMPONENTS'"

termux_step_post_extract_package() {
	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not ready for off-device builds."
	else
		echo "Stop and install these required build packages if you haven't already:"
		printf "$SWIFT_BUILD_PACKAGES\n\n"
	fi

	# The Swift build-script requires a particular organization of source directories,
	# which the following sets up.
	mkdir TEMP
	mv [a-zA-S]* TEMP/
	mv TEMP swift

	declare -A library_checksums
	library_checksums[swift-cmark]=dc02253fdc5ef4027551e5ab5cb8eef22abd7a5bb2df6a2baf02e17afdeeb5cd
	library_checksums[llvm-project]=0b3606be7b542aff28210c96639ad19a4b982e999fb3e86748198d8150f5f3d3
	library_checksums[swift-corelibs-libdispatch]=079cff5dd5b05381e9cf3094d445652fa9990a7d3a46e122f1e1dcdb2c54ddc1
	library_checksums[swift-corelibs-foundation]=f6e09efb3998d0a3d449f92ea809c86346c66e3b2d83ed19f3335bcb29401416
	library_checksums[swift-corelibs-xctest]=5996eb4384c8f095d912424439c5a1b7fc9ff57529f9ac5ecbc04e82d22ebca2
	library_checksums[swift-llbuild]=537683d7f1a73b48017d7cd7cd587c4b75c55cc5584e206cc0f8f92f6f4dd3ea
	library_checksums[swift-package-manager]=b421e7e171b94521e364b6ea21ddd6300fe28bce3a0fcbc9f5ed6db496f148a6

	for library in "${!library_checksums[@]}"; do \
		termux_download \
			https://github.com/apple/$library/archive/swift-$TERMUX_PKG_VERSION-RELEASE.tar.gz \
			$TERMUX_PKG_CACHEDIR/$library-$TERMUX_PKG_VERSION.tar.gz \
			${library_checksums[$library]}
		tar xf $TERMUX_PKG_CACHEDIR/$library-$TERMUX_PKG_VERSION.tar.gz
	        mv $library-swift-${TERMUX_PKG_VERSION}-RELEASE $library
	done

	mv swift-cmark cmark

	ln -s $PWD/llvm-project/llvm
	ln -s $PWD/llvm-project/compiler-rt
	ln -s $PWD/llvm-project/clang

	mv swift-llbuild llbuild
	mv swift-package-manager swiftpm
}

termux_step_pre_configure() {
	cd llbuild
	# The bare minimum patches needed from the existing llbuild package
	patch -p1 < $TERMUX_PKG_BUILDER_DIR/../llbuild/CMakeLists.txt.patch
	patch -p1 < $TERMUX_PKG_BUILDER_DIR/../llbuild/include-llvm-Config-config.h.patch
	patch -p1 < $TERMUX_PKG_BUILDER_DIR/../llbuild/lib-llvm-Support-CmakeLists.txt.patch
}

termux_step_configure() {
	if [ "$(dpkg-query -W -f '${db:Status-Status}\n' libdispatch 2>/dev/null)" == "installed" ]; then
		echo "This script will overwrite shared libraries provided by the libdispatch package."
		echo "Uninstall libdispatch first with 'pkg uninstall libdispatch'."
		termux_error_exit "Package '$TERMUX_PKG_NAME' overwrites 'libdispatch', so uninstall it."
	fi

	local PYTHON2_PATH=$(which python2)
	if [ -z "$PYTHON2_PATH" ]; then
		echo "Python 2 couldn't be found. Install these required build packages first:"
		echo "$SWIFT_BUILD_PACKAGES"
		termux_error_exit "Package '$TERMUX_PKG_NAME' requires Python 2 to build."
	else
		ln -s $PYTHON2_PATH python
		export PATH=$TERMUX_PKG_BUILDDIR:$PATH
	fi
}

termux_step_make() {
	SWIFT_BUILD_ROOT=$TERMUX_PKG_BUILDDIR $TERMUX_PKG_SRCDIR/swift/utils/build-script \
		$SWIFT_BUILD_FLAGS
}

termux_step_make_install() {
	SWIFT_BUILD_ROOT=$TERMUX_PKG_BUILDDIR $TERMUX_PKG_SRCDIR/swift/utils/build-script \
		$SWIFT_BUILD_FLAGS --install-swift --install-libdispatch --install-foundation \
		--install-xctest --install-swiftpm --llvm-install-components=IndexStore

	# A hack to remove libdispatch libraries installed by the above build-script, which would
	# overwrite the libdispatch package if installed.
	rm $TERMUX_PREFIX/lib/libdispatch.so $TERMUX_PREFIX/lib/libBlocksRuntime.so
	mkdir -p $TERMUX_PREFIX/lib/swift/pm/llbuild
	cp llbuild-android-aarch64/lib/libllbuildSwift.so $TERMUX_PREFIX/lib/swift/pm/llbuild
}
