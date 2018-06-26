TERMUX_PKG_HOMEPAGE=https://libgit2.github.com/
TERMUX_PKG_DESCRIPTION="C library implementing Git core methods"
TERMUX_PKG_VERSION=0.27.2
TERMUX_PKG_SHA256=ffacdbd5588aeb03e98e3866a7e2ceace468723a439bdc9bb01362fe140fa9e5
TERMUX_PKG_SRCURL=https://github.com/libgit2/libgit2/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libcurl, openssl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DBUILD_CLAR=OFF"
