TERMUX_PKG_HOMEPAGE=https://swift.org/
TERMUX_PKG_DESCRIPTION="Swift is a high-performance system programming language"
TERMUX_PKG_LICENSE="Apache-2.0, NCSA"
TERMUX_PKG_MAINTAINER="@finagolfin"
TERMUX_PKG_VERSION=6.4.3
SWIFT_RELEASE="RELEASE"
TERMUX_PKG_SRCURL=https://github.com/swiftlang/swift/archive/refs/tags/swift-$TERMUX_PKG_VERSION-$SWIFT_RELEASE.tar.gz
TERMUX_PKG_SHA256=bb81b230b21c408b5dd9aae46063961a129c7fbf1b68e844fef4f1871c96a5f2
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
	library_checksums[swift-cmark]=e6a8ffb7dd90b8c144481ca9f1ea7cead1b739d83b031bc8422823beb34d8540
	library_checksums[llvm-project]=bcdad215dea4f344b397f4ede33a311b157c05d9afa814ab2742288518d741ea
	library_checksums[swift-experimental-string-processing]=30f9968612b8a20f07c02d72e3d963a8df0faf7f17f82f888c34ab6b837dec81
	library_checksums[swift-syntax]=e12c4cf40442b33e2a06830a453594a3480c9b2141f37dc31a3c5fb4185b1812
	library_checksums[swift-corelibs-libdispatch]=87c3778dd2b3c9278a650bdaaf9ae42e5d85ef4d6c8bda70fb446a0a1c8f2b30
	library_checksums[swift-corelibs-foundation]=5dbff647b941ce93884535f5d90620a6dd49c1a7dc62e88f67e4843a26354602
	library_checksums[swift-foundation]=08479075c67dd30a2123e2a3cf3a821090c911451296570c214d7d693dc24faf
	library_checksums[swift-foundation-icu]=dd55659d4cb3fd07ef61232dd1f1da141baec6bb5703f61c3fddd41f8dea0cab
	library_checksums[swift-corelibs-xctest]=b694bf664c6ec3a954a327c23db0863be83f5c314de26044f9e8757dba0e7221
	library_checksums[swift-toolchain-sqlite]=dd2879b21ca9f2ceeadcd25881d3e1845f3db865026e2e7e7a2b1dfd62c637ec
	library_checksums[swift-llbuild]=e6345cdb0bc626439185fa9ea81b722f21b25e7056e20c79c580ad4c06505da3
	library_checksums[swift-testing]=229a3c1b6d763c358617fe603d66e93e6da3689f50f87458c77bdfa81deafaa8
	library_checksums[swift-argument-parser]=d2fbb15886115bb2d9bfb63d4c1ddd4080cbb4bfef2651335c5d3b9dd5f3c8ba
	library_checksums[swift-collections]=2f558b33b6eba5b0c263110d7cb1a11b59d63059e845dc1984c65359e36f29da
	library_checksums[swift-crypto]=cad9b04e5e23706bc3bf00ba6a976c397fea8111d964656a1a459fa4b1dc36a3
	library_checksums[swift-system]=4bf5d5db04d48f484289371b63dd7bdced0db1ab1307c49127b9f894341a521d
	library_checksums[swift-asn1]=45061bdf808ed138a71b55abc90c8cbff8980b82e5ffd39d86e65a5cbee31241
	library_checksums[swift-certificates]=1002a2aa66ced92dd216b9ed236d9ce8c73f98f02810f39f2437d43ba35d60a0
	library_checksums[swift-driver]=3dbff9469e061699208575c83b27e44ee64d2e48bdebdeab407de24ba57f470f
	library_checksums[swift-tools-protocols]=6d037891878c9d79de4b8cf9136d62e387815afef6a72670fae60b5191aa3a40
	library_checksums[swift-tools-support-core]=a3448e5378d3c83081a25774cc10c9f3129ef14f43eb3370d7f8304d02497b8f
	library_checksums[swift-build]=34bda90279b61c768a396f8e201a5057ce3ade25d87a441cb19d2fc4296a9c0a
	library_checksums[swift-package-manager]=9aba12344f20b2d7c717ced88a8805d884523523a6e7092d00ce0f2914e24723
	library_checksums[indexstore-db]=0d0bf81ff26c3b4584e769e3a69365f33dd8438103a6e09bc2cd720cad0d0a18
	library_checksums[swift-docc]=73cb78fb3c5c8a3bfc47c090731042a6d345380daee70533119e7d92cd0f0a50
	library_checksums[swift-docc-symbolkit]=c8e95818c655d132a0853c5a0f68ba444c821374966a59e6826d109a47988808
	library_checksums[swift-lmdb]=148da1b5f0e8737cb55f44992152d5bf682a0ede78d85feb20889bc1456f225e
	library_checksums[swift-markdown]=a2cc222da957c9e1dfdf7b109cd4cf243deb6571fa385700b8b7620d006d9f6f
	library_checksums[swift-nio]=d4b7d348e160044ddd395b4f0614eb92f25bf14ddc56d7e3a87816b283edab91
	library_checksums[swift-atomics]=33d9f4fbaeddee4bda3af2be126791ee8acf3d3c24a2244457641a20d39aec12
	library_checksums[sourcekit-lsp]=cbd66985b88989a7d6cb27e53de4830183069cf3f2538f5fe15591431f17f4da

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
