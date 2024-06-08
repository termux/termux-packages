TERMUX_PKG_HOMEPAGE=https://tiledb.com/
TERMUX_PKG_DESCRIPTION="A powerful engine for storing and accessing dense and sparse multi-dimensional arrays"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.24.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/TileDB-Inc/TileDB/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=21cd9ebe25ab0999927f375e7e92169e35e64dcceb7d17c91d0f310f9246ae1b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="ca-certificates, file, libbz2, libc++, liblz4, libspdlog, openssl, zlib, zstd"
TERMUX_PKG_BUILD_DEPENDS="clipp, fmt"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCOMPILER_SUPPORTS_AVX2=OFF
-DTILEDB_VCPKG=OFF
-DTILEDB_SUPERBUILD=OFF
-DTILEDB_WERROR=OFF
-DTILEDB_STATS=OFF
-DTILEDB_TESTS=OFF
-DTILEDB_WEBP=OFF
-DTILEDB_LIBMAGIC_EP_BUILT=ON
-Dlibmagic_INCLUDE_DIR=$TERMUX_PREFIX/include
-Dlibmagic_LIBRARIES=$TERMUX_PREFIX/lib/libmagic.so
-Dlibmagic_FOUND=ON
-Dlibmagic_DICTIONARY=$TERMUX_PREFIX/share/misc/magic.mgc
"

# XXX: TileDB assumes that `std::string_view::size_type` == `std::uint64_t`,
# XXX: but this is not true on 32-bit Android.
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"
