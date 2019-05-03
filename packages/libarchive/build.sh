TERMUX_PKG_HOMEPAGE=https://www.libarchive.org/
TERMUX_PKG_DESCRIPTION="Multi-format archive and compression library"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_VERSION=3.3.3
TERMUX_PKG_REVISION=4
TERMUX_PKG_SHA256=ba7eb1781c9fbbae178c4c6bad1c6eb08edab9a1496c64833d1715d022b30e2e
TERMUX_PKG_SRCURL=https://www.libarchive.org/downloads/libarchive-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libbz2, liblzma, libxml2, openssl, zlib"
# --without-nettle to use openssl instead:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--without-nettle
--without-lz4
--without-zstd
"
