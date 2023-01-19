TERMUX_PKG_HOMEPAGE=https://swift.org/
TERMUX_PKG_DESCRIPTION="Swift is a high-performance system programming language"
TERMUX_PKG_LICENSE="Apache-2.0, NCSA"
TERMUX_PKG_MAINTAINER="@buttaface"
TERMUX_PKG_VERSION=5.7.3
SWIFT_RELEASE="RELEASE"
TERMUX_PKG_SRCURL=https://github.com/apple/swift/archive/swift-$TERMUX_PKG_VERSION-$SWIFT_RELEASE.tar.gz
TERMUX_PKG_SHA256=8cda906403c12c5bf6ba4afea14fd494b6f08354e3e43be521f52e5cc5709eb8
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_DEPENDS="clang, libandroid-glob, libandroid-posix-semaphore, libandroid-spawn, libcurl, libicu, libicu-static, libsqlite, libuuid (>> 2.38.1), libxml2, libdispatch, llbuild"
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
	library_checksums[swift-cmark]=143a58286e611460ba5ffe3d53d8be5bfbe655f9eba4571201537bb417547b63
	library_checksums[llvm-project]=003e933dcfe8251ab0d809aba36d8f38d3cafa5946df2e0f0713962d9e5ebd62
	library_checksums[swift-experimental-string-processing]=86f5e1c9336fc4fc7529554418bff760aaafc8397dc29c4e56a5b1334dcdffba
	library_checksums[swift-corelibs-libdispatch]=4c6b7b0ecdf10e9cbe1cd007b9a09689ea412edb8e3a289ade6d105df43209f5
	library_checksums[swift-corelibs-foundation]=78852bcfcf703957953761cbd18a2398c31b25f26ddf3ac18983b959e1564f3d
	library_checksums[swift-corelibs-xctest]=4f152a62522008c09948202cd94d1d25c42b68ef5c8eb21abaa9855ea3e5a47f
	library_checksums[swift-llbuild]=bf1f1ca43d4f658813382ddb144d11f2ccd79ab7b10b31fde673087587310909
	library_checksums[swift-argument-parser]=a4d4c08cf280615fe6e00752ef60e28e76f07c25eb4706a9269bf38135cd9c3f
	library_checksums[Yams]=b31b6df500d6191368c93f605690ca9857fff7c6fd1c8897e9765fb624535c63
	library_checksums[swift-collections]=575cf0f88d9068411f9acc6e3ca5d542bef1cc9e87dc5d69f7b5a1d5aec8c6b6
	library_checksums[swift-crypto]=86d6c22c9f89394fd579e967b0d5d0b6ce33cdbf52ba70f82fa313baf70c759f
	library_checksums[swift-system]=865b8c380455eef27e73109835142920c60ae4c4f4178a3d12ad04acc83f1371
	library_checksums[swift-driver]=4a730616abd89191dfbebae888bc9c2436447868b69b2d4dcb7dbb2111ad2863
	library_checksums[swift-tools-support-core]=a0c54390f93642ee5df61bc65274c8c6a11e35177fb20188c1d9b710d69ef319
	library_checksums[swift-package-manager]=01ed764386cbac24c07497b192261746ddc961ce876f5f94bdcebccc1322105c
	library_checksums[indexstore-db]=210eff2343c4b122fd8622af7f0ad19cca41838dac66db8b5a35d477eaae79a0
	library_checksums[sourcekit-lsp]=cabcc7b5b839fff159210a04303660646ba2d1f51c9cf288c3a6df3373cbcd96

	for library in "${!library_checksums[@]}"; do \
		GH_ORG="apple"
		if [ "$library" = "swift-argument-parser" ]; then
			SRC_VERSION="1.0.3"
			TAR_NAME=$SRC_VERSION
		elif [ "$library" = "swift-collections" ]; then
			SRC_VERSION="1.0.1"
			TAR_NAME=$SRC_VERSION
		elif [ "$library" = "swift-crypto" ]; then
			SRC_VERSION="1.1.5"
			TAR_NAME=$SRC_VERSION
		elif [ "$library" = "swift-system" ]; then
			SRC_VERSION="1.1.1"
			TAR_NAME=$SRC_VERSION
		elif [ "$library" = "Yams" ]; then
			GH_ORG="jpsim"
			SRC_VERSION="5.0.0"
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
		--build-toolchain-only --host-cc=$CLANG --host-cxx=$CLANGXX
	fi
}

termux_step_make() {
	# The Swift compiler searches for the clang headers, so symlink against them using the clang major version.
	export TERMUX_CLANG_VERSION=$(. $TERMUX_SCRIPTDIR/packages/libllvm/build.sh; echo $LLVM_MAJOR_VERSION)

	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
	        termux_setup_swift
		ln -sf $TERMUX_PKG_HOSTBUILD_DIR/llvm-linux-x86_64 $TERMUX_PKG_BUILDDIR/llvm-linux-x86_64

		BOOTSTRAP=
		test $SWIFT_ARCH == 'armv7' && BOOTSTRAP='--bootstrapping=off'

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
