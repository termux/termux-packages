TERMUX_PKG_HOMEPAGE=https://swift.org/
TERMUX_PKG_DESCRIPTION="Swift is a high-performance system programming language"
TERMUX_PKG_LICENSE="Apache-2.0, NCSA"
TERMUX_PKG_MAINTAINER="@finagolfin"
TERMUX_PKG_VERSION=6.2.4
SWIFT_RELEASE="RELEASE"
TERMUX_PKG_SRCURL=https://github.com/swiftlang/swift/archive/refs/tags/swift-$TERMUX_PKG_VERSION-$SWIFT_RELEASE.tar.gz
TERMUX_PKG_SHA256=3b29b8aecfd6f401a2f46b28947850a53ac1cda46e54380fbd6d391c4f718fad
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_DEPENDS="clang, libandroid-execinfo, libandroid-glob, libandroid-posix-semaphore, libandroid-shmem, libandroid-spawn, libandroid-spawn-static, libandroid-sysv-semaphore, libcurl, libuuid, libxml2, libdispatch, llbuild, pkg-config, swift-sdk-${TERMUX_ARCH/_/-}"
TERMUX_PKG_BUILD_DEPENDS="rsync"
TERMUX_PKG_EXCLUDED_ARCHES="arm,x86_64,i686"
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
	library_checksums[swift-cmark]=6012b59d842b2864623901b1e9d527d5b314af87858e0af8661e191d92d14922
	library_checksums[llvm-project]=8e02cf861773b8b5b829b208ba892f240a8c3c6d336190c5eca32e393b783e4a
	library_checksums[swift-experimental-string-processing]=b0ab328fe9f80f08b71ee6c5e81c7c3a001c5d924b207b5a16d8027815ba1998
	library_checksums[swift-syntax]=53e644fb9c824cea726775e7b48ee5217323922917a7e1bc54fdc86e13058f80
	library_checksums[swift-corelibs-libdispatch]=09707e4ccdd19d4f23e356bf032b28fbf2b447c3645aff26775e25a97e314486
	library_checksums[swift-corelibs-foundation]=aa6a1e64b549bab1ea05a7470b3c3836bc1c3422972a3b28829f931593a3227d
	library_checksums[swift-foundation]=74cab7e91cf083465720f9c82dc57b659ec744d1ceba5964a0fdc4a3134f4687
	library_checksums[swift-foundation-icu]=ab52bcc8638ec3a88c6931838fcf101e0153a7c67ac359c91a7038a939acce93
	library_checksums[swift-corelibs-xctest]=ad39de9ecd0e0f08b519bac7ddd97a336e4428a01dd4f85c20575c049e661719
	library_checksums[swift-toolchain-sqlite]=c8704e70c4847a8dbd47aafb25d293fbe1e1bafade16cfa64e04f751e33db0ca
	library_checksums[swift-llbuild]=0c86a44d4ecfdb34a7b02fca2088e2a65415f8e91b4a803a6da38e678c92b6c5
	library_checksums[swift-testing]=5c10ae40206edad84f77c21acf04d7995d0ad3d8ab8af78b70b28aba2573ac4d
	library_checksums[swift-argument-parser]=d5bad3a1da66d9f4ceb0a347a197b8fdd243a91ff6b2d72b78efb052b9d6dd33
	library_checksums[swift-collections]=7e5e48d0dc2350bed5919be5cf60c485e72a30bd1f2baf718a619317677b91db
	library_checksums[swift-crypto]=5c860c0306d0393ff06268f361aaf958656e1288353a0e23c3ad20de04319154
	library_checksums[swift-system]=4bf5d5db04d48f484289371b63dd7bdced0db1ab1307c49127b9f894341a521d
	library_checksums[swift-asn1]=e0da995ae53e6fcf8251887f44d4030f6600e2f8f8451d9c92fcaf52b41b6c35
	library_checksums[swift-certificates]=fcaca458aab45ee69b0f678b72c2194b15664cc5f6f5e48d0e3f62bc5d1202ca
	library_checksums[swift-driver]=6a91a5da6144d677963e155f7d7a35d01f6c1baa05d6293dcf7f8f890b874266
	library_checksums[swift-tools-support-core]=3ace74183e7eac130ad899820b11570075eec7c80e6199d34a02a7731fad2e51
	library_checksums[swift-build]=08d8bbe371fb69af0174e706b63e8b8d15a0a1785efedeb8ad9e88f59e31f81c
	library_checksums[swift-package-manager]=38950fcee19d36cee62ed5e2ac5ac2c63414db9fe857c067f5f99243a1add52f
	library_checksums[indexstore-db]=c4caf104c2188af7b42ce160d5106b1227e66c358f7368a83e743af5df24d5ad
	library_checksums[swift-docc]=203ef84b43d586b8906be8537a62960d089c60717d59572d5b7b227c78647090
	library_checksums[swift-docc-symbolkit]=afb22446e5a37fac62c4dc4bfb9fd79023b1f7130117f9855c2c2604e8e1be4e
	library_checksums[swift-lmdb]=eb918a4ef4f0786e8ee8c5f64c51ffbb04677a95bb0289d1a81bd5273871d893
	library_checksums[swift-markdown]=51c2e23b538e45e49b442c50be0fdc0b045fa5b790dfb061d51538dbf2bae0d7
	library_checksums[swift-nio]=feb16b6d0e6d010be14c6732d7b02ddbbdc15a22e3912903f08ef5d73928f90d
	library_checksums[swift-atomics]=33d9f4fbaeddee4bda3af2be126791ee8acf3d3c24a2244457641a20d39aec12
	library_checksums[sourcekit-lsp]=9cd47c04fe1f81cb45d7c5258bb92ba205b6d1b6964147c7b6baf9833a50bbc4

	for library in "${!library_checksums[@]}"; do \
		GH_ORG="apple"
		if [ "$library" = "swift-argument-parser" ]; then
			SRC_VERSION="1.4.0"
			TAR_NAME=$SRC_VERSION
		elif [ "$library" = "swift-asn1" ]; then
			SRC_VERSION="1.0.0"
			TAR_NAME=$SRC_VERSION
		elif [ "$library" = "swift-atomics" ]; then
			SRC_VERSION="1.2.0"
			TAR_NAME=$SRC_VERSION
		elif [ "$library" = "swift-certificates" ]; then
			SRC_VERSION="1.0.1"
			TAR_NAME=$SRC_VERSION
		elif [ "$library" = "swift-collections" ]; then
			SRC_VERSION="1.1.3"
			TAR_NAME=$SRC_VERSION
		elif [ "$library" = "swift-crypto" ]; then
			SRC_VERSION="3.0.0"
			TAR_NAME=$SRC_VERSION
		elif [ "$library" = "swift-nio" ]; then
			SRC_VERSION="2.65.0"
			TAR_NAME=$SRC_VERSION
		elif [ "$library" = "swift-system" ]; then
			SRC_VERSION="1.5.0"
			TAR_NAME=$SRC_VERSION
		elif [ "$library" = "swift-toolchain-sqlite" ]; then
			GH_ORG="swiftlang"
			SRC_VERSION="1.0.1"
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
	echo "then you should try setting TERMUX_PKG_MAKE_PROCESSES=4 or a lower value."

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
	mv $TERMUX_PREFIX/lib/swift/android/lib_{Testing_,}Foundation*.so $TERMUX_PREFIX/opt/ndk-multilib/$TERMUX_ARCH-linux-android*/lib
	mv $TERMUX_PREFIX/lib/swift/android/lib*.a $TERMUX_PREFIX/lib/swift/android/$SWIFT_ARCH
	mv $TERMUX_PREFIX/lib/swift_static/android/lib*.a $TERMUX_PREFIX/lib/swift_static/android/$SWIFT_ARCH

	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		rm $TERMUX_PREFIX/swiftpm-android-$SWIFT_ARCH.json
	fi
}
