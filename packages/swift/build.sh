TERMUX_PKG_HOMEPAGE=https://swift.org/
TERMUX_PKG_DESCRIPTION="Swift is a high-performance system programming language"
TERMUX_PKG_LICENSE="Apache-2.0, NCSA"
TERMUX_PKG_MAINTAINER="@buttaface"
TERMUX_PKG_VERSION=5.6.2
TERMUX_PKG_REVISION=0
SWIFT_RELEASE="RELEASE"
TERMUX_PKG_SRCURL=https://github.com/apple/swift/archive/swift-$TERMUX_PKG_VERSION-$SWIFT_RELEASE.tar.gz
TERMUX_PKG_SHA256=8176efb376e83b358cd088683e5214d8db864386dae745f94618745b1ab89a19
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_DEPENDS="clang, libandroid-glob, libandroid-posix-semaphore, libandroid-spawn, libcurl, libicu, libicu-static, libsqlite, libuuid, libxml2, libdispatch, llbuild"
TERMUX_PKG_BUILD_DEPENDS="rsync"
TERMUX_PKG_BLACKLISTED_ARCHES="i686"
TERMUX_PKG_NO_STATICSPLIT=true
# Building swift uses CMake, but the standard
# termux_step_configure_cmake function is not used. Instead, we set
# TERMUX_PKG_FORCE_CMAKE to make the build system aware that CMake is
# needed.
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_CMAKE_BUILD=Ninja

SWIFT_COMPONENTS="autolink-driver;compiler;clang-resource-dir-symlink;swift-remote-mirror;parser-lib;license;sourcekit-inproc;stdlib;sdk-overlay"
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
	library_checksums[swift-cmark]=931dafb52749313bd7cefd743e9624d2cf244d7581e5540e82e33a0f866fbb31
	library_checksums[llvm-project]=dc876801beb1bcbbea9d023ff2aba6381ca5e63ad6462327e2191acf10804eb8
	library_checksums[swift-corelibs-libdispatch]=ddf90b72521cf836e5ff6537a140fa08c4a3227f9d52d308cb4571c517030c76
	library_checksums[swift-corelibs-foundation]=fc7be74a20938f9249ca104b9610a6d6e79f5e243f33d789d9795c3f247c57fa
	library_checksums[swift-corelibs-xctest]=4918429f4bc30b3cd8bd149096d56fd9f055c3ef82622934f64dddfa9aff9880
	library_checksums[swift-llbuild]=ba95bc71a20978bc5f411d10079de9ff228868f3fd9068d81b4be1998e5dc7d3
	library_checksums[swift-argument-parser]=a4d4c08cf280615fe6e00752ef60e28e76f07c25eb4706a9269bf38135cd9c3f
	library_checksums[Yams]=8bbb28ef994f60afe54668093d652e4d40831c79885fa92b1c2cd0e17e26735a
	library_checksums[swift-crypto]=86d6c22c9f89394fd579e967b0d5d0b6ce33cdbf52ba70f82fa313baf70c759f
	library_checksums[swift-system]=865b8c380455eef27e73109835142920c60ae4c4f4178a3d12ad04acc83f1371
	library_checksums[swift-driver]=97b515d684f26e9097bde7068e38f445898a8ab695478ca3ce64bc9969bc2fcb
	library_checksums[swift-tools-support-core]=d14a30cfd9628a59a44011cce0465d9fcb1e55fc74e62d7f807c98e66ddb822c
	library_checksums[swift-package-manager]=ea7eccebe14d84b9e12a8464a26acc2b8b094cd44eb1cc2c86c82d1ef5856c54
	library_checksums[indexstore-db]=6820ead230a04dc62c863f14a5db62ce8ba373257a4cb99e50096e32c83c9f5c
	library_checksums[sourcekit-lsp]=e1c70a099eb981b967baaf9f788af439633027c86a8b27cd39039b5c41e86700

	for library in "${!library_checksums[@]}"; do \
		GH_ORG="apple"
		if [ "$library" = "swift-argument-parser" ]; then
			SRC_VERSION="1.0.3"
			TAR_NAME=$SRC_VERSION
		elif [ "$library" = "swift-crypto" ]; then
			SRC_VERSION="1.1.5"
			TAR_NAME=$SRC_VERSION
		elif [ "$library" = "swift-system" ]; then
			SRC_VERSION="1.1.1"
			TAR_NAME=$SRC_VERSION
		elif [ "$library" = "Yams" ]; then
			GH_ORG="jpsim"
			SRC_VERSION="4.0.2"
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
		$SKIP_BUILD --skip-early-swift-driver --build-toolchain-only \
		--host-cc=$CLANG --host-cxx=$CLANGXX

		if [ "$TERMUX_ARCH" == "aarch64" ]; then
			rm $TERMUX_PKG_HOSTBUILD_DIR/swift-linux-x86_64/lib/swift/FrameworkABIBaseline
			cp -r $SWIFT_BINDIR/../lib/swift $TERMUX_PKG_HOSTBUILD_DIR/swift-linux-x86_64/lib
			ln -sf $SWIFT_BINDIR/../lib/clang/13.0.0 $TERMUX_PKG_HOSTBUILD_DIR/swift-linux-x86_64/lib/swift/clang
		fi
	fi
}

termux_step_pre_configure() {
	cd llvm-project
	patch -p1 < $TERMUX_PKG_BUILDER_DIR/../libllvm/clang-lib-Driver-ToolChain.cpp.patch
}

termux_step_make() {
	# The Swift compiler searches for the clang headers, so symlink against them using the clang major version.
	export TERMUX_CLANG_VERSION=$(. $TERMUX_SCRIPTDIR/packages/libllvm/build.sh; echo $LLVM_MAJOR_VERSION)

	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
	        termux_setup_swift
		ln -sf $TERMUX_PKG_HOSTBUILD_DIR/llvm-linux-x86_64 $TERMUX_PKG_BUILDDIR/llvm-linux-x86_64

		local SWIFT_TOOLCHAIN=
		if [ "$SWIFT_ARCH" = "aarch64" ]; then
			ln -sf $TERMUX_PKG_HOSTBUILD_DIR/swift-linux-x86_64 $TERMUX_PKG_BUILDDIR/swift-linux-x86_64
		else
			SWIFT_TOOLCHAIN="--native-swift-tools-path=$SWIFT_BINDIR"
		fi

		SWIFT_BUILD_FLAGS="$SWIFT_BUILD_FLAGS --android
		--android-ndk $TERMUX_STANDALONE_TOOLCHAIN --android-arch $SWIFT_ARCH
		--build-toolchain-only --skip-local-build --skip-local-host-install
		--cross-compile-hosts=android-$SWIFT_ARCH
		--cross-compile-deps-path=$(dirname $TERMUX_PREFIX)
		$SWIFT_TOOLCHAIN
		--native-clang-tools-path=$SWIFT_BINDIR
		--cross-compile-append-host-target-to-destdir=False"
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
