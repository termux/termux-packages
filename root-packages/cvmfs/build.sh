TERMUX_PKG_HOMEPAGE=https://cernvm.cern.ch/fs/
TERMUX_PKG_DESCRIPTION="The CernVM File System"
TERMUX_PKG_LICENSE="BSD-3-Clause"
TERMUX_PKG_MAINTAINER="@Crivella"
TERMUX_PKG_VERSION="2.13.3"
TERMUX_PKG_SRCURL=https://github.com/cvmfs/cvmfs/archive/refs/tags/cvmfs-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1ee9db980608d6cd25c6566c49acf5903b67e9110774563df4ca2397eb137393
# TERMUX_PKG_DEPENDS="libcurl, libcrypt, pacparser(XXX), zlib, leveldb, (maxminddb)XXX, libprotobuf, libsqlite, vjson(XXX), sha3(XXX), libarchive"
TERMUX_PKG_DEPENDS="c-ares, libc++, libandroid-execinfo, libcurl, zlib, leveldb, libprotobuf, protobuf, libsqlite, libarchive, libuuid, libcap, sparsehash, libfuse3"
# TERMUX_PKG_BUILD_DEPENDS="libprotobuf"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
# Needs its own build of:
# - sha3: fork of ... taking only subset of modified files
# - libcrypto: libressl
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

-DCMAKE_VERBOSE_MAKEFILE=ON

-DBUILTIN_EXTERNALS=ON
-DBUILTIN_EXTERNALS_LIST=vjson;sha3;libcrypto;pacparser

-DCARES_INCLUDE_DIR=$TERMUX_PREFIX/include
-DCARES_LIBRARY=$TERMUX_PREFIX/lib/libcares.so
-DFUSE3_INCLUDE_DIR=$TERMUX_PREFIX/include/fuse3
-DFUSE3_LIBRARY=$TERMUX_PREFIX/lib/libfuse3.so
-DSQLITE3_INCLUDE_DIR=$TERMUX_PREFIX/include
-DSQLITE3_LIBRARY=$TERMUX_PREFIX/lib/libsqlite3.so
-DLibArchive_INCLUDE_DIR=$TERMUX_PREFIX/include
-DLibArchive_LIBRARY=$TERMUX_PREFIX/lib/libarchive.so
-DSPARSEHASH_INCLUDE_DIR=$TERMUX_PREFIX/include/sparsehash

-DPACPARSER_INCLUDE_DIR=$TERMUX_PKG_SRCDIR/externals_install.aarch64/include
-DPACPARSER_LIBRARY=$TERMUX_PKG_SRCDIR/externals_install.aarch64/lib/libpacparser.a
-DVJSON_INCLUDE_DIRS=$TERMUX_PKG_SRCDIR/externals_install.aarch64/include
-DVJSON_LIBRARIES=$TERMUX_PKG_SRCDIR/externals_install.aarch64/lib/libvjson.a
-DSHA3_INCLUDE_DIRS=$TERMUX_PKG_SRCDIR/externals_install.aarch64/include
-DSHA3_LIBRARIES=$TERMUX_PKG_SRCDIR/externals_install.aarch64/lib/libsha3.a
-DLibcrypto_INCLUDE_DIRS=$TERMUX_PKG_SRCDIR/externals_install.aarch64/crypto/include
-DLibcrypto_LIBRARIES=$TERMUX_PKG_SRCDIR/externals_install.aarch64/crypto/lib/libcrypto.a
"
# -DBUILTIN_EXTERNALS_LIST=vjson;sha3;libcrypto;pacparser
# -DPACPARSER_INCLUDE_DIR=$TERMUX_PKG_SRCDIR/externals_install.aarch64/include
# -DPACPARSER_LIBRARY=$TERMUX_PKG_SRCDIR/externals_install.aarch64/lib/libpacparser.so
# -DPACPARSER_INCLUDE_DIR=$TERMUX_PREFIX/include
# -DPACPARSER_LIBRARY=$TERMUX_PREFIX/lib/libpacparser.so

# We cannot run cross-compiled programs to get help message, so disable
# man-page generation with help2man
# TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="ac_cv_prog_HELP2MAN="

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
