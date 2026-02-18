TERMUX_PKG_HOMEPAGE=https://swift.org/
TERMUX_PKG_DESCRIPTION="Swift is a high-performance system programming language"
TERMUX_PKG_LICENSE="Apache-2.0, NCSA"
TERMUX_PKG_MAINTAINER="@finagolfin"
TERMUX_PKG_VERSION=6.2.1
SWIFT_RELEASE="RELEASE"
TERMUX_PKG_SRCURL=https://github.com/swiftlang/swift/archive/refs/tags/swift-$TERMUX_PKG_VERSION-$SWIFT_RELEASE.tar.gz
TERMUX_PKG_SHA256=39825af3b1ab523ed4970e1315a14b5379fb5f8046170c27a330a179d982fe2a
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
	library_checksums[swift-cmark]=4f54c388f9a98527cf751ffedb35898c2198b4f23cf16d109203f9ba54a62379
	library_checksums[llvm-project]=c0bd5b4bc69dceda1dda5aabee6f24e42e87ec2ccb0ee5f002448ab3c4769fdf
	library_checksums[swift-experimental-string-processing]=a0055310ebc885ba4781edbcc9aaf44f7ae0cdbc633846bc0a9a6b3f53b29029
	library_checksums[swift-syntax]=c407424ca6da371425fbbe2a3f097f9df25118764a45b4a3af5e6d0ca4abc14a
	library_checksums[swift-corelibs-libdispatch]=18c6d5945e6668c1928deb72f524dfa26ad9d1b226c7d618cdf766885ccc433c
	library_checksums[swift-corelibs-foundation]=c395a3ca39291bda0f03946c2c4b5730ed02d629a3539adaf90184300228ea72
	library_checksums[swift-foundation]=411b967971eaa6c6ab4a1ba84fd145c17f4cb053515277bb903f18bf0183edb0
	library_checksums[swift-foundation-icu]=6e8ce5b8491821e840ea720b795264b5dcc98ad38ea122bc016593ac2be1f520
	library_checksums[swift-corelibs-xctest]=b0d7922af89146ab5a12d9744e965ca3bf587c9bbda2f435ab56a6dad86004a5
	library_checksums[swift-toolchain-sqlite]=c8704e70c4847a8dbd47aafb25d293fbe1e1bafade16cfa64e04f751e33db0ca
	library_checksums[swift-llbuild]=fdc26af47b53779776f1294f674886c774636ef0b0b1b2c2ed90f9626bd018ed
	library_checksums[swift-testing]=871e4eb07c1467dcac331f2bfa591cbd0a46dc2fee953f67f9b1402941fbd681
	library_checksums[swift-argument-parser]=d5bad3a1da66d9f4ceb0a347a197b8fdd243a91ff6b2d72b78efb052b9d6dd33
	library_checksums[swift-collections]=7e5e48d0dc2350bed5919be5cf60c485e72a30bd1f2baf718a619317677b91db
	library_checksums[swift-crypto]=5c860c0306d0393ff06268f361aaf958656e1288353a0e23c3ad20de04319154
	library_checksums[swift-system]=4bf5d5db04d48f484289371b63dd7bdced0db1ab1307c49127b9f894341a521d
	library_checksums[swift-asn1]=e0da995ae53e6fcf8251887f44d4030f6600e2f8f8451d9c92fcaf52b41b6c35
	library_checksums[swift-certificates]=fcaca458aab45ee69b0f678b72c2194b15664cc5f6f5e48d0e3f62bc5d1202ca
	library_checksums[swift-driver]=004db94c753b437c7ec8260a27f0b79509389503e661dacd244547fdfa1edc23
	library_checksums[swift-tools-support-core]=a1783534192eaef6de498c10ac02fab70aa64cbc9750252b30ff856046962530
	library_checksums[swift-build]=6284de0771da435c99af96aa1109029ffa47c18a3fb507d1c3266c42e9e7b0f1
	library_checksums[swift-package-manager]=b8f9d96ec4095e46d021dce896d47991ab30d7a487511054a9e630aff4303e42
	library_checksums[indexstore-db]=d13695451dfdbb5719527ec66f588da1f5b350553c231655d5dc1e4e84105cec
	library_checksums[swift-docc]=954dcba69da56c63e1636f0dece60d4c8c1250e6bc2b97e20f72e50b068fdd1d
	library_checksums[swift-docc-symbolkit]=47e9b732a3e03a803e962333f6934d2648e6685f17328dad7c56874047366b1d
	library_checksums[swift-lmdb]=0e60fb6e3ff82253c529f1e0e902f556e8749c963ceb4db8305d2af152da465e
	library_checksums[swift-markdown]=2cdb1751c22a22eb16b92cd12bb7c7d27d7af103173df1893c2c813dc2098a9e
	library_checksums[swift-nio]=feb16b6d0e6d010be14c6732d7b02ddbbdc15a22e3912903f08ef5d73928f90d
	library_checksums[swift-atomics]=33d9f4fbaeddee4bda3af2be126791ee8acf3d3c24a2244457641a20d39aec12
	library_checksums[sourcekit-lsp]=0ff9f6f2547b6585512193ee6d87980bc45b71051e19a74d3f09ba257b8123fe

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
