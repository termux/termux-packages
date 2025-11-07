TERMUX_PKG_HOMEPAGE=https://cernvm.cern.ch/fs/
TERMUX_PKG_DESCRIPTION="The CernVM File System"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@Crivella"
TERMUX_PKG_VERSION="2.13.3"
TERMUX_PKG_SRCURL=https://github.com/cvmfs/cvmfs/archive/refs/tags/cvmfs-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1ee9db980608d6cd25c6566c49acf5903b67e9110774563df4ca2397eb137393
TERMUX_PKG_DEPENDS="c-ares, libc++, libandroid-execinfo, libandroid-posix-semaphore, libcurl, zlib, libprotobuf, protobuf, libsqlite, libarchive, libuuid, libcap, libfuse3"
TERMUX_PKG_BUILD_DEPENDS="sparsehash"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_CVMFS=ON
-DBUILD_LIBCVMFS=ON
-DBUILD_UBENCHMARKS=OFF
-DBUILD_QC_TESTS=OFF
-DBUILD_GATEWAY=OFF
-DBUILD_SERVER=OFF
-DBUILD_DUCC=OFF
-DBUILD_SNAPSHOTTER=OFF
-DBUILD_STRESS_TESTS=OFF

-DBUILTIN_EXTERNALS=ON
-DBUILTIN_EXTERNALS_LIST=vjson;sha3;libcrypto;pacparser;leveldb;

-DCARES_INCLUDE_DIR=$TERMUX_PREFIX/include
-DCARES_LIBRARY=$TERMUX_PREFIX/lib/libcares.so
-DFUSE3_INCLUDE_DIR=$TERMUX_PREFIX/include/fuse3
-DFUSE3_LIBRARY=$TERMUX_PREFIX/lib/libfuse3.so
-DSQLITE3_INCLUDE_DIR=$TERMUX_PREFIX/include
-DSQLITE3_LIBRARY=$TERMUX_PREFIX/lib/libsqlite3.so
-DLibArchive_INCLUDE_DIR=$TERMUX_PREFIX/include
-DLibArchive_LIBRARY=$TERMUX_PREFIX/lib/libarchive.so
-DSPARSEHASH_INCLUDE_DIR=$TERMUX_PREFIX/include/sparsehash

-DLEVELDB_INCLUDE_DIR=$TERMUX_PKG_SRCDIR/externals_install.${TERMUX_ARCH}/include
-DLEVELDB_LIBRARIES=$TERMUX_PKG_SRCDIR/externals_install.${TERMUX_ARCH}/lib/libleveldb.a
-DPACPARSER_INCLUDE_DIR=$TERMUX_PKG_SRCDIR/externals_install.${TERMUX_ARCH}/include
-DPACPARSER_LIBRARY=$TERMUX_PKG_SRCDIR/externals_install.${TERMUX_ARCH}/lib/libpacparser.a
-DVJSON_INCLUDE_DIRS=$TERMUX_PKG_SRCDIR/externals_install.${TERMUX_ARCH}/include
-DVJSON_LIBRARIES=$TERMUX_PKG_SRCDIR/externals_install.${TERMUX_ARCH}/lib/libvjson.a
-DSHA3_INCLUDE_DIRS=$TERMUX_PKG_SRCDIR/externals_install.${TERMUX_ARCH}/include
-DSHA3_LIBRARIES=$TERMUX_PKG_SRCDIR/externals_install.${TERMUX_ARCH}/lib/libsha3.a
-DLibcrypto_INCLUDE_DIRS=$TERMUX_PKG_SRCDIR/externals_install.${TERMUX_ARCH}/crypto/include
-DLibcrypto_LIBRARIES=$TERMUX_PKG_SRCDIR/externals_install.${TERMUX_ARCH}/crypto/lib/libcrypto.a
"

termux_step_pre_configure () {
	# Get `protoc` that can be used on host architecture during build
	termux_setup_protobuf

	# for backtrace and backtrace_symbols_fd
	LDFLAGS+=" -landroid-execinfo"

	# Make variables available to build scripts
	export TERMUX_HOST_PLATFORM
	export TERMUX_PKG_API_LEVEL
	export CLANG_TARGET_TRIPLE="${TERMUX_HOST_PLATFORM}${TERMUX_PKG_API_LEVEL}"
	export TERMUX_STANDALONE_TOOLCHAIN
	export LDFLAGS
}
