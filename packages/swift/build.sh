TERMUX_PKG_HOMEPAGE=https://swift.org/
TERMUX_PKG_DESCRIPTION="Swift is a high-performance system programming language"
TERMUX_PKG_LICENSE="Apache-2.0, NCSA"
TERMUX_PKG_MAINTAINER="@finagolfin"
TERMUX_PKG_VERSION=6.0.2
SWIFT_RELEASE="RELEASE"
TERMUX_PKG_SRCURL=https://github.com/swiftlang/swift/archive/swift-$TERMUX_PKG_VERSION-$SWIFT_RELEASE.tar.gz
TERMUX_PKG_SHA256=1489681860e92cee5ddd869a06531d7a1746b2f4ea105a2ff3b631ebcbcffd34
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_DEPENDS="clang, libandroid-execinfo, libandroid-glob, libandroid-posix-semaphore, libandroid-shmem, libandroid-spawn, libandroid-spawn-static, libandroid-sysv-semaphore, libcurl, libsqlite, libuuid, libxml2, libdispatch, llbuild, pkg-config, swift-sdk-${TERMUX_ARCH/_/-}"
TERMUX_PKG_BUILD_DEPENDS="rsync"
TERMUX_PKG_BLACKLISTED_ARCHES="i686, riscv64"
TERMUX_PKG_NO_STATICSPLIT=true
# Temporary hack only needed for x86_64
TERMUX_PKG_UNDEF_SYMBOLS_FILES="
./opt/ndk-multilib/arm-linux-androideabi/lib/libFoundation.so
./opt/ndk-multilib/arm-linux-androideabi/lib/libFoundationNetworking.so
./opt/ndk-multilib/x86_64-linux-android/lib/libFoundation.so
./opt/ndk-multilib/x86_64-linux-android/lib/libFoundationNetworking.so
"
# Building swift uses CMake, but the standard
# termux_step_configure_cmake function is not used. Instead, we set
# TERMUX_PKG_FORCE_CMAKE to make the build system aware that CMake is
# needed.
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_CMAKE_BUILD=Ninja

SWIFT_COMPONENTS="autolink-driver;compiler;clang-resource-dir-symlink;swift-remote-mirror;license;sourcekit-inproc;static-mirror-lib;stdlib;sdk-overlay"
SWIFT_TOOLCHAIN_FLAGS="-RA --llvm-targets-to-build='X86;ARM;AArch64' -j $TERMUX_PKG_MAKE_PROCESSES --install-prefix=$TERMUX_PREFIX"
SWIFT_PATH_FLAGS="--build-subdir=. --install-destdir=/"
SWIFT_BUILD_FLAGS="$SWIFT_TOOLCHAIN_FLAGS $SWIFT_PATH_FLAGS"

SWIFT_ARCH=$TERMUX_ARCH
test $SWIFT_ARCH == 'arm' && SWIFT_ARCH='armv7'

termux_step_post_get_source() {
	# The Swift build-script requires a particular organization of source
	# directories, which the following downloads and sets up.
	mkdir .temp
	mv [a-zA-Z]* .temp/
	mv .temp swift

	declare -A library_checksums
	library_checksums[swift-cmark]=2bfeab8747f4bcfea6aa70ed0494fe2185ec2532f1c9b7a0e17214cd401e9f31
	library_checksums[llvm-project]=991e9d63548a5ae8ce4fdda4052e98cb2bf2b193cafac8bbeea8f830f8cede96
	library_checksums[swift-experimental-string-processing]=e0380895e1cf5dc49aef321256f8192986185a6fa6ea83c143f171b643450fc0
	library_checksums[swift-syntax]=82cb7640775a23cf7483197f0cd6a6342a29a61d4bb75239905490bf47a64a75
	library_checksums[swift-corelibs-libdispatch]=3df429b22d9294c0ca5291c86e83a35f6326600a1c271933107bba199b919008
	library_checksums[swift-corelibs-foundation]=8af719f14a05cee2d32625cf455261fc74d13eeef3ba9e5b9547316743d5cde9
	library_checksums[swift-foundation]=a677ad3a712fb4d8330bccd28904aaa1b10749264d57ad9370215a89156ba1d3
	library_checksums[swift-foundation-icu]=a48f0d6f998ba6db710f89f0e987c4cf00f3845338afae116ab3e29c04dad127
	library_checksums[swift-corelibs-xctest]=a671062f178c68dd1fb0fdcf6a7c00589b343a63009a59b522206e03c9850d97
	library_checksums[swift-llbuild]=40ada0511f0218fb3ca0478c8fff1b4d0958478056a0cc5408677753e8c8f7a7
	library_checksums[swift-argument-parser]=4a10bbef290a2167c5cc340b39f1f7ff6a8cf4e1b5433b68548bf5f1e542e908
	library_checksums[Yams]=a81c6b93f5d26bae1b619b7f8babbfe7c8abacf95b85916961d488888df886fb
	library_checksums[swift-collections]=cd30d2f93c72424df48d182006417abdeebe74d250cb99d1cda78daf40aca569
	library_checksums[swift-crypto]=5c860c0306d0393ff06268f361aaf958656e1288353a0e23c3ad20de04319154
	library_checksums[swift-system]=02e13a7f77887c387f5aa1de05f4d4b8b158c35145450e1d9557d6c42b06cd1f
	library_checksums[swift-asn1]=e0da995ae53e6fcf8251887f44d4030f6600e2f8f8451d9c92fcaf52b41b6c35
	library_checksums[swift-certificates]=fcaca458aab45ee69b0f678b72c2194b15664cc5f6f5e48d0e3f62bc5d1202ca
	library_checksums[swift-driver]=c6db9d058c8d5122f8e368087e397d59cf17ce5be686d4713025269658f0467e
	library_checksums[swift-tools-support-core]=2f88a0790e9fe6fc0efa6a1fc1382d71c010126f871a6516ba56fb05dd1d23a0
	library_checksums[swift-package-manager]=00e40c3bce9b63fdd24d783909af003c7f86431898ee6b8bf44174d023d08402
	library_checksums[indexstore-db]=61f6d010edc11f31b5e01efb3628958501a1883b07ee4c741bbebc8c7d43d03d
	library_checksums[sourcekit-lsp]=26175c4774f9817ad32c62c004ca76e9f09d8b77a253fca0e4eafdb33f33b2d2

	for library in "${!library_checksums[@]}"; do \
		GH_ORG="apple"
		if [ "$library" = "swift-argument-parser" ]; then
			SRC_VERSION="1.2.3"
			TAR_NAME=$SRC_VERSION
		elif [ "$library" = "swift-asn1" ]; then
			SRC_VERSION="1.0.0"
			TAR_NAME=$SRC_VERSION
		elif [ "$library" = "swift-certificates" ]; then
			SRC_VERSION="1.0.1"
			TAR_NAME=$SRC_VERSION
		elif [ "$library" = "swift-collections" ]; then
			SRC_VERSION="1.1.2"
			TAR_NAME=$SRC_VERSION
		elif [ "$library" = "swift-crypto" ]; then
			SRC_VERSION="3.0.0"
			TAR_NAME=$SRC_VERSION
		elif [ "$library" = "swift-system" ]; then
			SRC_VERSION="1.3.0"
			TAR_NAME=$SRC_VERSION
		elif [ "$library" = "Yams" ]; then
			GH_ORG="jpsim"
			SRC_VERSION="5.0.6"
			TAR_NAME=$SRC_VERSION
		else
			GH_ORG="swiftlang"
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

		local CLANG=$(command -v clang)
		local CLANGXX=$(command -v clang++)

		# The Ubuntu CI may not have clang/clang++ in its path so explicitly set it
		# to clang-17 instead.
		if [ -z "$CLANG" ]; then
			CLANG=$(command -v clang-17)
			CLANGXX=$(command -v clang++-17)
		fi

		# Natively compile llvm-tblgen and some other files needed later.
		SWIFT_BUILD_ROOT=$TERMUX_PKG_HOSTBUILD_DIR $TERMUX_PKG_SRCDIR/swift/utils/build-script \
		-R --no-assertions -j $TERMUX_PKG_MAKE_PROCESSES $SWIFT_PATH_FLAGS \
		--skip-build-cmark --skip-build-llvm --skip-build-swift --skip-early-swift-driver \
		--skip-early-swiftsyntax --build-toolchain-only --host-cc=$CLANG --host-cxx=$CLANGXX
	fi
}

termux_step_make() {
	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		termux_setup_swift
		ln -sf $TERMUX_PKG_HOSTBUILD_DIR/llvm-linux-x86_64 $TERMUX_PKG_BUILDDIR/llvm-linux-x86_64
		for header in execinfo.h glob.h iconv.h spawn.h sys/sem.h sys/shm.h; do
			ln -sf $TERMUX_PREFIX/include/$header $TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/include/$header
		done

		SWIFT_BUILD_FLAGS="$SWIFT_BUILD_FLAGS --android
		--android-ndk $TERMUX_STANDALONE_TOOLCHAIN --android-arch $SWIFT_ARCH
		--build-toolchain-only --skip-local-build --skip-local-host-install
		--cross-compile-hosts=android-$SWIFT_ARCH
		--cross-compile-deps-path=$(dirname $TERMUX_PREFIX)
		--native-swift-tools-path=$SWIFT_BINDIR
		--native-clang-tools-path=$SWIFT_BINDIR
		--cross-compile-append-host-target-to-destdir=False"
	fi

	SWIFT_BUILD_ROOT=$TERMUX_PKG_BUILDDIR $TERMUX_PKG_SRCDIR/swift/utils/build-script \
	$SWIFT_BUILD_FLAGS --xctest -b -p --swift-driver --sourcekit-lsp \
	--android-api-level $TERMUX_PKG_API_LEVEL --build-swift-static-stdlib \
	--swift-install-components=$SWIFT_COMPONENTS --llvm-install-components=IndexStore \
	--install-llvm --install-swift --install-libdispatch --install-foundation \
	--install-xctest --install-llbuild --install-swiftpm --install-swift-driver --install-sourcekit-lsp

	rm $TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/include/{execinfo.h,glob.h,iconv.h,spawn.h,sys/sem.h,sys/shm.h}
}

termux_step_make_install() {
	rm -rf $TERMUX_PREFIX/lib/swift{,_static}/{Block,os}
	rm $TERMUX_PREFIX/lib/swift{,_static}/dispatch/*.h
	rm $TERMUX_PREFIX/lib/swift/android/lib{dispatch,BlocksRuntime}.so
	mv $TERMUX_PREFIX/lib/swift/android/lib[^_]*.so $TERMUX_PREFIX/opt/ndk-multilib/$TERMUX_ARCH-linux-android*/lib
	mv $TERMUX_PREFIX/lib/swift/android/lib_FoundationICU.so $TERMUX_PREFIX/opt/ndk-multilib/$TERMUX_ARCH-linux-android*/lib
	mv $TERMUX_PREFIX/lib/swift/android/lib*.a $TERMUX_PREFIX/lib/swift/android/$SWIFT_ARCH
	mv $TERMUX_PREFIX/lib/swift_static/android/lib*.a $TERMUX_PREFIX/lib/swift_static/android/$SWIFT_ARCH

	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		rm $TERMUX_PREFIX/swiftpm-android-$SWIFT_ARCH.json
	fi
}
