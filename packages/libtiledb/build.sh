TERMUX_PKG_HOMEPAGE=https://tiledb.com/
TERMUX_PKG_DESCRIPTION="A powerful engine for storing and accessing dense and sparse multi-dimensional arrays"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.30.1"
TERMUX_PKG_SRCURL="https://github.com/TileDB-Inc/TileDB/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=36381f9eaa2a6defc8990aa1a95d1f0e87971748a50bf6fb705bf032ac7384cf
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="ca-certificates, file, fmt, libblosc2, libbz2, libc++, liblz4, libspdlog, openssl, zlib, zstd"
TERMUX_PKG_BUILD_DEPENDS="clipp, nlohmann-json"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCOMPILER_SUPPORTS_AVX2=OFF
-DTILEDB_DISABLE_AUTO_VCPKG=ON
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
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"
