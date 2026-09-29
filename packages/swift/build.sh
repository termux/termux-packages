TERMUX_PKG_HOMEPAGE=https://swift.org/
TERMUX_PKG_DESCRIPTION="Swift is a high-performance system programming language"
TERMUX_PKG_LICENSE="Apache-2.0, NCSA"
TERMUX_PKG_MAINTAINER="@finagolfin"
TERMUX_PKG_VERSION=6.4.0
SWIFT_RELEASE="RELEASE"
TERMUX_PKG_SRCURL=https://github.com/swiftlang/swift/archive/refs/tags/swift-$TERMUX_PKG_VERSION-$SWIFT_RELEASE.tar.gz
TERMUX_PKG_SHA256=8ac51c183d353a5b0f42cf0718f09977bf8723595a99f2218fe7458023cdead7
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
	library_checksums[swift-cmark]=9af8e991bf20e756edf43d294ed2de7a1595c47d42d2335e3917c629682c8002
	library_checksums[llvm-project]=3d2f5b300f3f07dfaea33ad15fbbfc54552325a62551fb15ab1667fc33326e01
	library_checksums[swift-experimental-string-processing]=4070e40df8ae59f008539f89edcba01197b9bfaaee8f364a2edf2b9825469479
	library_checksums[swift-syntax]=4b56cd709c66d0f581e7649c8533c2f93599ee88f41d68ffed7004be75bb629e
	library_checksums[swift-corelibs-libdispatch]=af15fcc3da4514def6454ed672b82daa9ac1d40cb1d08fb69a6611cb8fc104c6
	library_checksums[swift-corelibs-foundation]=4d54f115ca4f24f77117c97e64760f6379bb45745a5c79d52a2877fe84c6ad5c
	library_checksums[swift-foundation]=cd7b137cb279425ee494e61a3552b361fd4e764031fc9ae75cc8c5876b8eec3e
	library_checksums[swift-foundation-icu]=1bc3f6f49783da52b7d6d65e08f9b3a0ba3063c341176a9139c2cea9c9c348f0
	library_checksums[swift-corelibs-xctest]=c7fc1058e766270155652311794a660f4b62ca9f8db125d2222e2a8695d9975a
	library_checksums[swift-toolchain-sqlite]=dd2879b21ca9f2ceeadcd25881d3e1845f3db865026e2e7e7a2b1dfd62c637ec
	library_checksums[swift-llbuild]=4ea396e158eea664deffdf414c93872cc8e512b42bdd4bb29ad4cbdb108097aa
	library_checksums[swift-testing]=d1f1c91a308f2642ce0f35afd0da057ee8bd31814332f5b257ae5bd69c48de22
	library_checksums[swift-argument-parser]=d2fbb15886115bb2d9bfb63d4c1ddd4080cbb4bfef2651335c5d3b9dd5f3c8ba
	library_checksums[swift-collections]=2f558b33b6eba5b0c263110d7cb1a11b59d63059e845dc1984c65359e36f29da
	library_checksums[swift-crypto]=cad9b04e5e23706bc3bf00ba6a976c397fea8111d964656a1a459fa4b1dc36a3
	library_checksums[swift-system]=4bf5d5db04d48f484289371b63dd7bdced0db1ab1307c49127b9f894341a521d
	library_checksums[swift-asn1]=45061bdf808ed138a71b55abc90c8cbff8980b82e5ffd39d86e65a5cbee31241
	library_checksums[swift-certificates]=1002a2aa66ced92dd216b9ed236d9ce8c73f98f02810f39f2437d43ba35d60a0
	library_checksums[swift-driver]=aecca17753f5f9b03867a92e568ab9a0023159928afb02e9ff496e1430c6d0b6
	library_checksums[swift-tools-protocols]=5c73f3fb051e00a1faf9e4c1a9dc2b99f3d43ccf72a757224e8c1984bf214cc9
	library_checksums[swift-tools-support-core]=4daaf31f3b020b28813e2a67d651b3efdf7be9b38b25902e8180bd46ba57fe07
	library_checksums[swift-build]=5a7f1f35ae8783ca7d5791f68110dfba663f647307a4fc2e076e325efc603855
	library_checksums[swift-package-manager]=f706803df332f855e3db9bd405dc242351c4491997e172225b8677c109e6cc70
	library_checksums[indexstore-db]=f31f54cd3f0971b122a782e3ce267574f039f1a46005f02fea3ae6012be8ca49
	library_checksums[swift-docc]=a31f00fa298bca55435e3c44174bcdf256bfdd85e63f40aa46b72cf4f6f91cff
	library_checksums[swift-docc-symbolkit]=6c5a5544fd71d5ea56206df9b0cdd29e3f5ba9e5d57f72ed12ca30a3637c4f61
	library_checksums[swift-lmdb]=2fd1d06c7baea81cf3850bb01fe4d15a98dd6da8f1ca2859550bd1d3fce3f7fd
	library_checksums[swift-markdown]=01086ecb144b75bb24bce24853a9646130d63998f4fa10d202890f51d3098375
	library_checksums[swift-nio]=d4b7d348e160044ddd395b4f0614eb92f25bf14ddc56d7e3a87816b283edab91
	library_checksums[swift-atomics]=33d9f4fbaeddee4bda3af2be126791ee8acf3d3c24a2244457641a20d39aec12
	library_checksums[sourcekit-lsp]=deae16ff60092ccf24d4ee453ef261e7f2cc1b4df730b443c72b7b5ded66286c

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
			SRC_VERSION="2.92.2"
			TAR_NAME=$SRC_VERSION
		elif [ "$library" = "swift-system" ]; then
			SRC_VERSION="1.5.0"
			TAR_NAME=$SRC_VERSION
		elif [ "$library" = "swift-toolchain-sqlite" ]; then
			GH_ORG="swiftlang"
			SRC_VERSION="1.0.9"
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
