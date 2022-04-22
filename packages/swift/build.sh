TERMUX_PKG_HOMEPAGE=https://swift.org/
TERMUX_PKG_DESCRIPTION="Swift is a high-performance system programming language"
TERMUX_PKG_LICENSE="Apache-2.0, NCSA"
TERMUX_PKG_MAINTAINER="@buttaface"
TERMUX_PKG_VERSION=5.6.1
TERMUX_PKG_REVISION=1
SWIFT_RELEASE="RELEASE"
TERMUX_PKG_SRCURL=https://github.com/apple/swift/archive/swift-$TERMUX_PKG_VERSION-$SWIFT_RELEASE.tar.gz
TERMUX_PKG_SHA256=39e4e2b7343756e26627b945a384e1b828e38778b34cc5b0f3ecc23f18d22fd6
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_DEPENDS="clang, libandroid-glob, libandroid-posix-semaphore, libandroid-spawn, libcurl, libicu, libicu-static, libsqlite, libuuid, libxml2, libdispatch, llbuild"
TERMUX_PKG_BUILD_DEPENDS="rsync"
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
	library_checksums[swift-cmark]=3a5c35b8018b079d99cae3305c9ede9c940aa298db0af92c418461fb0de289b6
	library_checksums[llvm-project]=24343a2a7059b7cfc25c0acc884ebf9296209440ac0fe5948e541b168d818777
	library_checksums[swift-corelibs-libdispatch]=856c9ffcf2ab2bbb28a6e0fa344277fc41aa0771419b283c7c4db69dad2b4cf9
	library_checksums[swift-corelibs-foundation]=21d28ad500279eb66bb8dc9e33e4c8036e1472f30e82eeb76329b69aa4b622fc
	library_checksums[swift-corelibs-xctest]=6a2f6a81a5dd295578b2b80522313e36b4d3e51c828fe8210b1c84c2f66237ca
	library_checksums[swift-llbuild]=3fe038b9b76a90803205d41f440eec46f21f23f42fd6f15be756b68907d04502
	library_checksums[swift-argument-parser]=a4d4c08cf280615fe6e00752ef60e28e76f07c25eb4706a9269bf38135cd9c3f
	library_checksums[Yams]=8bbb28ef994f60afe54668093d652e4d40831c79885fa92b1c2cd0e17e26735a
	library_checksums[swift-crypto]=86d6c22c9f89394fd579e967b0d5d0b6ce33cdbf52ba70f82fa313baf70c759f
	library_checksums[swift-system]=865b8c380455eef27e73109835142920c60ae4c4f4178a3d12ad04acc83f1371
	library_checksums[swift-driver]=94c1eba97cdb71594d1f432d80a08d33578c9911f3968a8cb946e9d8bbe4d20f
	library_checksums[swift-tools-support-core]=5fecacc1e35e659eee9aeafb0cb84b894f08c9094520fd56eb7e131b9eb5a991
	library_checksums[swift-package-manager]=0b375bbd0cc0b9296351064e0a012ca450675ce5021b2a029278463457026382
	library_checksums[indexstore-db]=3cf0eddc514f89b86b07bf479f39fc83ded3aa2bfeaaca2b48729142ff976426
	library_checksums[sourcekit-lsp]=a6f74d7bf4ee3615d4ac747a4b3747cfa8736b3d07274aeaba27f38886627cd7

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

	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		termux_download \
			https://download.swift.org/swift-$TERMUX_PKG_VERSION-release/ubuntu2004/swift-$TERMUX_PKG_VERSION-$SWIFT_RELEASE/$SWIFT_BIN.tar.gz \
			$TERMUX_PKG_CACHEDIR/$SWIFT_BIN.tar.gz \
			2b4f22d4a8b59fe8e050f0b7f020f8d8f12553cbda56709b2340a4a3bb90cfea
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
		$SKIP_BUILD --skip-early-swift-driver --build-toolchain-only \
		--host-cc=$CLANG --host-cxx=$CLANGXX

		tar xf $TERMUX_PKG_CACHEDIR/$SWIFT_BIN.tar.gz -C $TERMUX_PKG_HOSTBUILD_DIR
		if [ "$TERMUX_ARCH" == "aarch64" ]; then
			rm $TERMUX_PKG_HOSTBUILD_DIR/swift-linux-x86_64/lib/swift/FrameworkABIBaseline
			cp -r $SWIFT_BIN/usr/lib/swift $TERMUX_PKG_HOSTBUILD_DIR/swift-linux-x86_64/lib
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
