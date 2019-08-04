TERMUX_PKG_HOMEPAGE=https://www.libarchive.org/
TERMUX_PKG_DESCRIPTION="Multi-format archive and compression library"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_VERSION=3.4.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=8643d50ed40c759f5412a3af4e353cffbce4fdf3b5cf321cb72cacf06b2d825e
TERMUX_PKG_SRCURL=https://github.com/libarchive/libarchive/releases/download/v$TERMUX_PKG_VERSION/libarchive-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_DEPENDS="libbz2, libiconv, liblzma, libxml2, openssl, zlib"
TERMUX_PKG_BREAKS="libarchive-dev"
TERMUX_PKG_REPLACES="libarchive-dev"

# --without-nettle to use openssl instead:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--without-nettle
--without-lz4
--without-zstd
"
