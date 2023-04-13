TERMUX_PKG_HOMEPAGE=https://swift.org/
TERMUX_PKG_DESCRIPTION="Swift is a high-performance system programming language"
TERMUX_PKG_LICENSE="Apache-2.0, NCSA"
TERMUX_PKG_MAINTAINER="@buttaface"
TERMUX_PKG_VERSION=5.8
TERMUX_PKG_REVISION=1
SWIFT_RELEASE="RELEASE"
TERMUX_PKG_SRCURL=https://github.com/apple/swift/archive/swift-$TERMUX_PKG_VERSION-$SWIFT_RELEASE.tar.gz
TERMUX_PKG_SHA256=16c68b4c4872651d4fc7e361df7731b7cc2592b293473d41bd331cd1a1fc3887
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_DEPENDS="clang, libandroid-glob, libandroid-posix-semaphore, libandroid-spawn, libcurl, libicu, libicu-static, libsqlite, libuuid, libxml2, libdispatch, llbuild, swift-sdk-${TERMUX_ARCH/_/-}"
TERMUX_PKG_BUILD_DEPENDS="rsync"
TERMUX_PKG_BLACKLISTED_ARCHES="i686"
TERMUX_PKG_NO_STATICSPLIT=true
# Building swift uses CMake, but the standard
# termux_step_configure_cmake function is not used. Instead, we set
# TERMUX_PKG_FORCE_CMAKE to make the build system aware that CMake is
# needed.
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_CMAKE_BUILD=Ninja

SWIFT_COMPONENTS="autolink-driver;compiler;clang-resource-dir-symlink;swift-remote-mirror;license;sourcekit-inproc;static-mirror-lib;stdlib;sdk-overlay"
SWIFT_TOOLCHAIN_FLAGS="-RA --llvm-targets-to-build='X86;ARM;AArch64' -j $TERMUX_MAKE_PROCESSES"
SWIFT_PATH_FLAGS="--build-subdir=. --install-destdir=/ --install-prefix=$TERMUX_PREFIX"
SWIFT_BUILD_FLAGS="$SWIFT_TOOLCHAIN_FLAGS $SWIFT_PATH_FLAGS"

SWIFT_ARCH=$TERMUX_ARCH
test $SWIFT_ARCH == 'arm' && SWIFT_ARCH='armv7'

termux_step_post_get_source() {
	# The Swift build-script requires a particular organization of source
	# directories, which the following sets up.
	mkdir .temp
	mv [a-zA-Z]* .temp/
	mv .temp swift

	declare -A library_checksums
	library_checksums[swift-cmark]=e3de63c4a6672e13e7b7aa80dcbe2361fbac507851440a0ac61e20f1cb470119
	library_checksums[llvm-project]=8435ea5e39d34c74b1a2600376eff4b217f9933830e23d6cf67521513fce7706
	library_checksums[swift-experimental-string-processing]=ff4507448e31a011d51b3143ef1ba9e8694886dab4cd89ca202f42b79d1c9e0c
	library_checksums[swift-syntax]=24ed18b53c4339caff746be184c16d75bd394ed10c9cebddfa776c83a47b5d9b
	library_checksums[swift-corelibs-libdispatch]=391d2bcaea22c4aa980400c3a29b3d9991641aa62253b693c0b79c302eafd5a0
	library_checksums[swift-corelibs-foundation]=ff7e5903c80364a1531ab4af7e6fe861998a069e425d6a842fa6ca0236504a9c
	library_checksums[swift-corelibs-xctest]=b5a007afd43d702d31a1bfc165e3ded0142b0526a56b1a532351b8d751b2499f
	library_checksums[swift-llbuild]=6345ae69ac9b8bb61b61f14871b322f83b1d08f70c261bd9a2f86a998c394c0c
	library_checksums[swift-argument-parser]=a4d4c08cf280615fe6e00752ef60e28e76f07c25eb4706a9269bf38135cd9c3f
	library_checksums[Yams]=ec1ad699c30f0db45520006c63a88cc1c946a7d7b36dff32a96460388c0a4af2
	library_checksums[swift-collections]=575cf0f88d9068411f9acc6e3ca5d542bef1cc9e87dc5d69f7b5a1d5aec8c6b6
	library_checksums[swift-crypto]=84cec042505e1c5bf3dd14a1bb18d0c06c5a9435b7b10a69709101b602285ff5
	library_checksums[swift-system]=865b8c380455eef27e73109835142920c60ae4c4f4178a3d12ad04acc83f1371
	library_checksums[swift-driver]=1ae19fe5c953df382d174ef4f99b3c7511d32a0037cb043ebd5f681c3d2504dd
	library_checksums[swift-tools-support-core]=6651c7f798f291386ac2d9e4be35cf25b26db4669d2ef3ad215ff3631f8850d6
	library_checksums[swift-package-manager]=2cc1b39452e5b615170d5d9ba4fdef81e8e644124af11e3affb8e385c2219f32
	library_checksums[indexstore-db]=f02a8646ce03cd89cc3db18ee460a1395c1f2285ee656e15c8c24c21f14eca31
	library_checksums[sourcekit-lsp]=cb74c4212e2387a5e8d8fba0ba96dad79191294275366e6c8b2cce9c07d9ea61

	for library in "${!library_checksums[@]}"; do \
		GH_ORG="apple"
		if [ "$library" = "swift-argument-parser" ]; then
			SRC_VERSION="1.0.3"
			TAR_NAME=$SRC_VERSION
		elif [ "$library" = "swift-collections" ]; then
			SRC_VERSION="1.0.1"
			TAR_NAME=$SRC_VERSION
		elif [ "$library" = "swift-crypto" ]; then
			SRC_VERSION="2.2.3"
			TAR_NAME=$SRC_VERSION
		elif [ "$library" = "swift-system" ]; then
			SRC_VERSION="1.1.1"
			TAR_NAME=$SRC_VERSION
		elif [ "$library" = "Yams" ]; then
			GH_ORG="jpsim"
			SRC_VERSION="5.0.1"
			TAR_NAME=$SRC_VERSION
		else
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
}

termux_step_host_build() {
	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		termux_setup_cmake
		termux_setup_ninja
		termux_setup_swift

		local CLANG=$(command -v clang)
		local CLANGXX=$(command -v clang++)

		# The Ubuntu CI may not have clang/clang++ in its path so explicitly set it
		# to clang-13 instead.
		if [ -z "$CLANG" ]; then
			CLANG=$(command -v clang-13)
			CLANGXX=$(command -v clang++-13)
		fi

		# Natively compile llvm-tblgen and some other files needed later.
		SWIFT_BUILD_ROOT=$TERMUX_PKG_HOSTBUILD_DIR $TERMUX_PKG_SRCDIR/swift/utils/build-script \
		-R --no-assertions -j $TERMUX_MAKE_PROCESSES $SWIFT_PATH_FLAGS \
		--skip-build-cmark --skip-build-llvm --skip-build-swift --skip-early-swift-driver \
		--skip-early-swiftsyntax --build-toolchain-only --host-cc=$CLANG --host-cxx=$CLANGXX
	fi
}

termux_step_make() {
	# The Swift compiler searches for the clang headers, so symlink against them using the clang major version.
	export TERMUX_CLANG_VERSION=$(. $TERMUX_SCRIPTDIR/packages/libllvm/build.sh; echo $LLVM_MAJOR_VERSION)

	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
	        termux_setup_swift
		ln -sf $TERMUX_PKG_HOSTBUILD_DIR/llvm-linux-x86_64 $TERMUX_PKG_BUILDDIR/llvm-linux-x86_64

		BOOTSTRAP='--bootstrapping=off'

		SWIFT_BUILD_FLAGS="$SWIFT_BUILD_FLAGS --android
		--android-ndk $TERMUX_STANDALONE_TOOLCHAIN --android-arch $SWIFT_ARCH
		--build-toolchain-only --skip-local-build --skip-local-host-install
		--cross-compile-hosts=android-$SWIFT_ARCH $BOOTSTRAP
		--cross-compile-deps-path=$(dirname $TERMUX_PREFIX)
		--native-swift-tools-path=$SWIFT_BINDIR
		--native-clang-tools-path=$SWIFT_BINDIR
		--cross-compile-append-host-target-to-destdir=False"
	fi

	SWIFT_BUILD_ROOT=$TERMUX_PKG_BUILDDIR $TERMUX_PKG_SRCDIR/swift/utils/build-script \
	$SWIFT_BUILD_FLAGS --xctest -b -p --swift-driver --sourcekit-lsp \
	--android-api-level $TERMUX_PKG_API_LEVEL --skip-early-swiftsyntax \
	--build-swift-static-stdlib --swift-install-components=$SWIFT_COMPONENTS \
	--llvm-install-components=IndexStore --install-llvm --install-swift \
	--install-libdispatch --install-foundation --install-xctest --install-llbuild \
	--install-swiftpm --install-swift-driver --install-sourcekit-lsp
}

termux_step_make_install() {
	rm $TERMUX_PREFIX/lib/swift/pm/llbuild/libllbuild.so
	rm $TERMUX_PREFIX/lib/swift/android/lib{dispatch,BlocksRuntime}.so
	mv $TERMUX_PREFIX/lib/swift/android/lib[^_]*.so $TERMUX_PREFIX/opt/ndk-multilib/$TERMUX_ARCH-linux-android*/lib
	mv $TERMUX_PREFIX/lib/swift/android/lib*.a $TERMUX_PREFIX/lib/swift/android/$SWIFT_ARCH
	mv $TERMUX_PREFIX/lib/swift_static/android/lib*.a $TERMUX_PREFIX/lib/swift_static/android/$SWIFT_ARCH

	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		rm $TERMUX_PREFIX/swiftpm-android-$SWIFT_ARCH.json
		mv $TERMUX_PREFIX/glibc-native.modulemap \
			$TERMUX_PREFIX/lib/swift/android/$SWIFT_ARCH/glibc.modulemap
	fi
}
