TERMUX_PKG_HOMEPAGE=https://www.libarchive.org/
TERMUX_PKG_DESCRIPTION="Multi-format archive and compression library"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.5.1
TERMUX_PKG_SRCURL=https://github.com/libarchive/libarchive/releases/download/$TERMUX_PKG_VERSION/libarchive-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=9015d109ec00bb9ae1a384b172bf2fc1dff41e2c66e5a9eeddf933af9db37f5a
TERMUX_PKG_DEPENDS="libbz2, libiconv, liblzma, libxml2, openssl, zlib"
TERMUX_PKG_BREAKS="libarchive-dev"
TERMUX_PKG_REPLACES="libarchive-dev"

# --without-nettle to use openssl instead:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--without-nettle
--without-lz4
--without-zstd
--disable-acl
--disable-xattr
"
