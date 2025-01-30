TERMUX_PKG_HOMEPAGE=https://github.com/apache/arrow
TERMUX_PKG_DESCRIPTION="C++ libraries for Apache Arrow"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
# Align the version with `python-pyarrow` package.
TERMUX_PKG_VERSION="19.0.0"
TERMUX_PKG_SRCURL=https://github.com/apache/arrow/archive/refs/tags/apache-arrow-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7bee51bb6c1176eb08070bd2c7fb7e9e4d17f277e59c9cf80a88082443b124de
TERMUX_PKG_DEPENDS="abseil-cpp, apache-orc, libandroid-execinfo, libc++, liblz4, libprotobuf, libre2, libsnappy, thrift, utf8proc, zlib, zstd"
TERMUX_PKG_BUILD_DEPENDS="boost, boost-headers, rapidjson"
TERMUX_PKG_BREAKS="libarrow-python (<< ${TERMUX_PKG_VERSION})"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DARROW_BUILD_STATIC=OFF
-DARROW_CSV=ON
-DARROW_DATASET=ON
-DARROW_HDFS=ON
-DARROW_JEMALLOC=OFF
-DARROW_JSON=ON
-DARROW_ORC=ON
-DARROW_PARQUET=ON
-DARROW_RUNTIME_SIMD_LEVEL=NONE
-DARROW_SIMD_LEVEL=NONE
-DLZ4_HOME=$TERMUX_PREFIX
-DSNAPPY_HOME=$TERMUX_PREFIX
-DZLIB_HOME=$TERMUX_PREFIX
-DZSTD_HOME=$TERMUX_PREFIX
"

termux_step_pre_configure() {
	termux_setup_protobuf

	TERMUX_PKG_SRCDIR+="/cpp"

	CPPFLAGS+=" -DPROTOBUF_USE_DLLS"
	LDFLAGS+=" -landroid-execinfo"

	# Fix linker script error for zlib 1.3
	LDFLAGS+=" -Wl,--undefined-version"
}
