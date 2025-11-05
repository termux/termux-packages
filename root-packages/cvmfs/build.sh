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
    termux_setup_cmake
    # Get `protoc` that can be used on host architecture during build
    termux_setup_protobuf

    # export CFLAGS="${CFLAGS} -isystem/usr/include"

    # Make variables available to build scripts
    export TERMUX_HOST_PLATFORM
    export TERMUX_PKG_API_LEVEL
    export CLANG_TARGET_TRIPLE="${TERMUX_HOST_PLATFORM}${TERMUX_PKG_API_LEVEL}"
    export TERMUX_STANDALONE_TOOLCHAIN
    # export CCOMP_FLAGS="--target=${CLANG_TARGET_TRIPLE} --sysroot=$(TERMUX_STANDALONE_TOOLCHAIN)/sysroot"
}

# termux_step_make () {
#     cmake --build . -- -j 1 # -j $TERMUX_PKG_MAKE_PROCESSES
# }

# -DLibcrypto_INCLUDE_DIRS=$TERMUX_PREFIX/include
# -DLibcrypto_LIBRARIES=$TERMUX_PREFIX/lib/libcrypto.so

# -DSHA3_INCLUDE_DIRS=/home/builder/.termux-build/cvmfs/src/externals_install.aarch64/include
# -DSHA3_LIBRARIES=/home/builder/.termux-build/cvmfs/src/externals_install.aarch64/lib/libsha3.a
# -DBUILTIN_EXTERNALS_LIST=vjson;sha3;maxminddb

# TERMUX_PKG_DEPENDS="keyutils, libblkid, libcap, libdevmapper, libevent, libmount, libnl, libsqlite, libtirpc, libuuid, openldap"
# TERMUX_PKG_BUILD_DEPENDS="libxml2"
# TERMUX_PKG_AUTO_UPDATE=true
# TERMUX_PKG_BUILD_IN_SRC=true
# TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
# ac_cv_lib_resolv___res_querydomain=yes
# libsqlite3_cv_is_recent=yes
# --disable-gss
# --disable-sbin-override
# --with-modprobedir=$TERMUX_PREFIX/lib/modprobe.d
# --with-mountfile=$TERMUX_PREFIX/etc/nfsmounts.conf
# --with-nfsconfig=$TERMUX_PREFIX/etc/nfs.conf
# --with-start-statd=$TERMUX_PREFIX/bin/start-statd
# --with-statedir=$TERMUX_PREFIX/var/lib/nfs
# "
# TERMUX_PKG_RM_AFTER_INSTALL="
# lib/udev
# "

# termux_step_pre_configure() {
# 	autoreconf -fi

# 	CPPFLAGS+=" -D__USE_GNU"

# 	local _lib="$TERMUX_PKG_BUILDDIR/_lib"
# 	rm -rf "${_lib}"
# 	mkdir -p "${_lib}"
# 	pushd "${_lib}"
# 	local f
# 	for f in strverscmp versionsort; do
# 		$CC $CFLAGS $CPPFLAGS "$TERMUX_PKG_BUILDER_DIR/${f}.c" \
# 			-fvisibility=hidden -c -o "./${f}.o"
# 	done
# 	$AR cru libversionsort.a strverscmp.o versionsort.o
# 	echo '!<arch>' > libresolv.a
# 	popd

# 	LDFLAGS+=" -L${_lib} -l:libversionsort.a"
# }
