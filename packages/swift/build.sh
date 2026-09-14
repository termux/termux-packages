TERMUX_PKG_HOMEPAGE=https://swift.org/
TERMUX_PKG_DESCRIPTION="Swift is a high-performance system programming language"
TERMUX_PKG_LICENSE="Apache-2.0, NCSA"
TERMUX_PKG_MAINTAINER="@finagolfin"
TERMUX_PKG_VERSION=6.3.3
TERMUX_PKG_REVISION=1
SWIFT_RELEASE="RELEASE"
TERMUX_PKG_SRCURL=https://github.com/swiftlang/swift/archive/refs/tags/swift-$TERMUX_PKG_VERSION-$SWIFT_RELEASE.tar.gz
TERMUX_PKG_SHA256=a96425b6626ede8518423810450763da541fb28501e27009badb6a6f6534c411
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_DEPENDS="clang, libandroid-execinfo, libandroid-glob, libandroid-posix-semaphore, libandroid-shmem, libandroid-spawn, libandroid-spawn-static, libandroid-sysv-semaphore, libcurl, libuuid, libxml2, libdispatch, llbuild, pkg-config, swift-sdk-${TERMUX_ARCH/_/-}"
TERMUX_PKG_BUILD_DEPENDS="rsync"
TERMUX_PKG_EXCLUDED_ARCHES="i686"
TERMUX_PKG_NO_STATICSPLIT=true
# Building swift uses CMake, but the standard
# termux_step_configure_cmake function is not used. Instead, we set
# TERMUX_PKG_FORCE_CMAKE to make the build system aware that CMake is
# needed.
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_CMAKE_BUILD=Ninja

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
	library_checksums[swift-cmark]=c9f981c268b4d2beca1d43878f5dd1d69dc629e62157bc400064d6c6111e2020
	library_checksums[llvm-project]=4e0bfc8045a1036d3a49c65d411ffca1e4b6af117ac2bf5070871f375c097610
	library_checksums[swift-experimental-string-processing]=1ca338ea222031f5d67fa34922a55111ffb67524197f33a6be0540abaafe0b52
	library_checksums[swift-syntax]=94d58f82c8d3c1831283f85c64f3485a9caf1e9c0834d7142feac5bfcf6fc3d9
	library_checksums[swift-corelibs-libdispatch]=c3a61c08387937622a291e08e64eb4ec0be07f1df252574552641129057951bb
	library_checksums[swift-corelibs-foundation]=cfba08125b15c3138f6d1e2b6cf5058ef2f294f3a08c54ef322d903a5002c20d
	library_checksums[swift-foundation]=23972ee7ef5e103fa2a9df2704abce787b0f64073fec3df1846c2f2039bf0f3d
	library_checksums[swift-foundation-icu]=3568e41730bce792bb90fbc592ad37df319a62352587ff134a8e554751063cf8
	library_checksums[swift-corelibs-xctest]=0255806248b1bb21c09dd7f798b6db8068eb56d88a7e28bb3b667f70277efa66
	library_checksums[swift-toolchain-sqlite]=5a267a6eff88bd8e7d23ed0713cb8f3955f57ef71539da2d1c64b54c4865b3ea
	library_checksums[swift-llbuild]=89d9267a1ae741c4d12a58fa3f81a3d07985b5947795eb2edbb41ead373f6a46
	library_checksums[swift-testing]=926c9bf7c1ad4eaedb7913f0bb79221734adc87c46bc664f40de6f8d78ce9d91
	library_checksums[swift-argument-parser]=d2fbb15886115bb2d9bfb63d4c1ddd4080cbb4bfef2651335c5d3b9dd5f3c8ba
	library_checksums[swift-collections]=2f558b33b6eba5b0c263110d7cb1a11b59d63059e845dc1984c65359e36f29da
	library_checksums[swift-crypto]=cad9b04e5e23706bc3bf00ba6a976c397fea8111d964656a1a459fa4b1dc36a3
	library_checksums[swift-system]=4bf5d5db04d48f484289371b63dd7bdced0db1ab1307c49127b9f894341a521d
	library_checksums[swift-asn1]=45061bdf808ed138a71b55abc90c8cbff8980b82e5ffd39d86e65a5cbee31241
	library_checksums[swift-certificates]=1002a2aa66ced92dd216b9ed236d9ce8c73f98f02810f39f2437d43ba35d60a0
	library_checksums[swift-driver]=d4fcada9b5ad99ed9194b3fae35de234a56d80e833dc19016ac8e904dcc7cd76
	library_checksums[swift-tools-protocols]=cc23820a634523d6dac4bb3abd6d659f7ede50a4f38bb4b10188775095d8e000
	library_checksums[swift-tools-support-core]=df4dc7e94360d3af711b78d28691df1082faf389d0db78c0ea702e2217a4036f
	library_checksums[swift-build]=8bb78bb89d03489f0e5a529b2a1dbb29e98de947b187b2bc282a6ae4f939d663
	library_checksums[swift-package-manager]=191a953608b99241cd53e9f02d0ddbdbccd32bb4cb5c6aaff3e47b78003dfa94
	library_checksums[indexstore-db]=c49a8c3481dfbdd37abd58800a6f6654b52cf051200ea9bcfc2fe2535d3f8841
	library_checksums[swift-docc]=c785529e3ddcf4ee982a26c9ee4e2ec30175fc9ec0727bf9b0cd26c638b14393
	library_checksums[swift-docc-symbolkit]=02457ea2dc733f66d39a1db7b9a1bc75b39acaee228da09caaa1a15c5207543c
	library_checksums[swift-lmdb]=b8b14a954f737e2cc45458c52e17def09a474448346febf4d4f73deaba9905a5
	library_checksums[swift-markdown]=93684a45e81577a8640292e406c7e645adf9c9e143c59527e833cd49609c98cf
	library_checksums[swift-nio]=feb16b6d0e6d010be14c6732d7b02ddbbdc15a22e3912903f08ef5d73928f90d
	library_checksums[swift-atomics]=33d9f4fbaeddee4bda3af2be126791ee8acf3d3c24a2244457641a20d39aec12
	library_checksums[sourcekit-lsp]=6f79fb228df8b5c50e8b47ec7ee588de0a8240aaf45a1d5ce7bbf2a733dcaf42

	for library in "${!library_checksums[@]}"; do \
		GH_ORG="apple"
		if [ "$library" = "swift-argument-parser" ]; then
			SRC_VERSION="1.6.1"
			TAR_NAME=$SRC_VERSION
		elif [ "$library" = "swift-asn1" ]; then
			SRC_VERSION="1.3.2"
			TAR_NAME=$SRC_VERSION
		elif [ "$library" = "swift-atomics" ]; then
			SRC_VERSION="1.2.0"
			TAR_NAME=$SRC_VERSION
		elif [ "$library" = "swift-certificates" ]; then
			SRC_VERSION="1.10.1"
			TAR_NAME=$SRC_VERSION
		elif [ "$library" = "swift-collections" ]; then
			SRC_VERSION="1.1.6"
			TAR_NAME=$SRC_VERSION
		elif [ "$library" = "swift-crypto" ]; then
			SRC_VERSION="3.12.5"
			TAR_NAME=$SRC_VERSION
		elif [ "$library" = "swift-nio" ]; then
			SRC_VERSION="2.65.0"
			TAR_NAME=$SRC_VERSION
		elif [ "$library" = "swift-system" ]; then
			SRC_VERSION="1.5.0"
			TAR_NAME=$SRC_VERSION
		elif [ "$library" = "swift-toolchain-sqlite" ]; then
			GH_ORG="swiftlang"
			SRC_VERSION="1.0.7"
			TAR_NAME=$SRC_VERSION
		elif [ "$library" = "swift-tools-protocols" ]; then
			GH_ORG="swiftlang"
			SRC_VERSION="0.0.9"
			TAR_NAME=$SRC_VERSION
		else
			GH_ORG="swiftlang"
			SRC_VERSION=$SWIFT_RELEASE
			TAR_NAME=swift-$TERMUX_PKG_VERSION-$SWIFT_RELEASE
		fi

		termux_download \
			https://github.com/$GH_ORG/$library/archive/refs/tags/$TAR_NAME.tar.gz \
			$TERMUX_PKG_CACHEDIR/$library-$SRC_VERSION.tar.gz \
			${library_checksums[$library]}
		tar xf $TERMUX_PKG_CACHEDIR/$library-$SRC_VERSION.tar.gz
		mv $library-$TAR_NAME $library
	done

	mv swift-cmark cmark
	mv swift-llbuild llbuild
	mv swift-package-manager swiftpm
}

termux_step_host_build() {
	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		termux_setup_cmake
		termux_setup_ninja

		local CLANG=$(command -v clang)
		local CLANGXX=$(command -v clang++)

		# The Ubuntu Docker image (sometimes used by CI but sometimes not)
		# might not have clang/clang++ in its path, so explicitly set it
		# to the versioned system clang if necessary.
		if [ -z "$CLANG" ]; then
			CLANG="$TERMUX_HOST_LLVM_BASE_DIR/bin/clang"
			CLANGXX="$TERMUX_HOST_LLVM_BASE_DIR/bin/clang++"
		fi

		# Natively compile llvm-tblgen and some other files needed later.
		SWIFT_BUILD_ROOT=$TERMUX_PKG_HOSTBUILD_DIR $TERMUX_PKG_SRCDIR/swift/utils/build-script \
		-R --no-assertions -j $TERMUX_PKG_MAKE_PROCESSES $SWIFT_PATH_FLAGS \
		--skip-build-cmark --skip-build-llvm --skip-build-swift --skip-early-swift-driver \
		--skip-early-swiftsyntax --build-toolchain-only --host-cc=$CLANG --host-cxx=$CLANGXX
	fi
}

termux_step_make() {
	echo "WARNING: if you experience errors like 'ld.lld: error: unable to find library -lswiftCore',"
	echo "report the error to the termux-packages repo. You can work around this build race"
	echo "for now by setting TERMUX_PKG_MAKE_PROCESSES=4 or a lower value."

	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		termux_setup_swift
		# hack to get the Ubuntu 24.04 toolchain running on 26.04, until we can update
		patchelf --replace-needed libxml2.so.2 libxml2.so $SWIFT_BINDIR/../lib/swift/linux/libFoundationXML.so
		ln -sf $TERMUX_PKG_HOSTBUILD_DIR/llvm-linux-x86_64 $TERMUX_PKG_BUILDDIR/llvm-linux-x86_64
		for header in execinfo.h glob.h iconv.h spawn.h sys/sem.h sys/shm.h; do
			ln -sf $TERMUX_PREFIX/include/$header $TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/include/$header
		done
		unset ANDROID_NDK_ROOT

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
	$SWIFT_BUILD_FLAGS --xctest --swift-testing -b -p --swift-driver --sourcekit-lsp \
	--android-api-level $TERMUX_PKG_API_LEVEL --build-swift-static-stdlib \
	--swift-install-components=$SWIFT_COMPONENTS --llvm-install-components=IndexStore \
	--install-llvm --install-swift --install-libdispatch --install-foundation \
	--install-xctest --install-llbuild --install-swift-testing --install-swiftpm \
	--install-swift-driver --install-sourcekit-lsp

	rm $TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/include/{execinfo.h,glob.h,iconv.h,spawn.h,sys/sem.h,sys/shm.h}
	rm $TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib/swift
}

termux_step_make_install() {
	rm -rf $TERMUX_PREFIX/lib/swift{,_static}/{Block,os}
	rm $TERMUX_PREFIX/lib/swift{,_static}/dispatch/*.h
	rm $TERMUX_PREFIX/lib/swift/android/lib{dispatch,BlocksRuntime}.so
	mv $TERMUX_PREFIX/lib/swift/android/lib[^_]*.so $TERMUX_PREFIX/opt/ndk-multilib/$TERMUX_ARCH-linux-android*/lib
	mv $TERMUX_PREFIX/lib/swift/android/lib_{Testing,Foundation}*.so $TERMUX_PREFIX/opt/ndk-multilib/$TERMUX_ARCH-linux-android*/lib
	mv $TERMUX_PREFIX/lib/swift/android/lib*.a $TERMUX_PREFIX/lib/swift/android/$SWIFT_ARCH
	mv $TERMUX_PREFIX/lib/swift_static/android/lib*.a $TERMUX_PREFIX/lib/swift_static/android/$SWIFT_ARCH

	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		rm $TERMUX_PREFIX/swiftpm-android-$SWIFT_ARCH.json
	fi
}
