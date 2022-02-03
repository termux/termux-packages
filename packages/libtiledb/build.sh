TERMUX_PKG_HOMEPAGE=https://tiledb.com/
TERMUX_PKG_DESCRIPTION="A powerful engine for storing and accessing dense and sparse multi-dimensional arrays"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.6.2
TERMUX_PKG_SRCURL=https://github.com/TileDB-Inc/TileDB/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6974dd4e53edabda75cc8fa6b5772c71d6adb3eaafa76397e0542b3606f6f783
TERMUX_PKG_DEPENDS="ca-certificates, libbz2, libc++, liblz4, libspdlog, openssl, zlib, zstd"
TERMUX_PKG_BUILD_DEPENDS="clipp, fmt"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DTILEDB_SUPERBUILD=OFF
-DTILEDB_WERROR=OFF
-DTILEDB_STATS=OFF
-DTILEDB_TESTS=OFF
-DHAVE_AVX2_EXITCODE=1
-DHAVE_AVX2_EXITCODE__TRYRUN_OUTPUT=
"
