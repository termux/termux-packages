TERMUX_PKG_HOMEPAGE=https://www.libarchive.org/
TERMUX_PKG_DESCRIPTION="Multi-format archive and compression library"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.6.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/libarchive/libarchive/releases/download/v$TERMUX_PKG_VERSION/libarchive-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=a36613695ffa2905fdedc997b6df04a3006ccfd71d747a339b78aa8412c3d852
TERMUX_PKG_AUTO_UPDATE=true
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
