TERMUX_PKG_HOMEPAGE=https://libgit2.github.com/
TERMUX_PKG_DESCRIPTION="C library implementing Git core methods"
TERMUX_PKG_VERSION=0.26.3
TERMUX_PKG_SHA256=0da4e211dfb63c22e5f43f2a4a5373e86a140afa88a25ca6ba3cc2cae58263d2
TERMUX_PKG_SRCURL=https://github.com/libgit2/libgit2/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libcurl, openssl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DBUILD_CLAR=OFF"
