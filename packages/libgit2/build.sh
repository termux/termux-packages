TERMUX_PKG_HOMEPAGE=https://libgit2.github.com/
TERMUX_PKG_DESCRIPTION="C library implementing Git core methods"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_SRCURL=https://github.com/libgit2/libgit2/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6a1fa16a7f6335ce8b2630fbdbb5e57c4027929ebc56fcd1ac55edb141b409b4
TERMUX_PKG_DEPENDS="libcurl, openssl, libssh2, zlib"
TERMUX_PKG_BREAKS="libgit2-dev"
TERMUX_PKG_REPLACES="libgit2-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DBUILD_CLAR=OFF"
