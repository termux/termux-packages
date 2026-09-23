TERMUX_PKG_HOMEPAGE=https://github.com/podofo/podofo
TERMUX_PKG_DESCRIPTION="A C++ library to work with the PDF file format"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.1.2"
TERMUX_PKG_SRCURL=https://github.com/podofo/podofo/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d6ffe6fc173ac6d6e5b00f5cb9db01990cab1bdf7cc03bdeffce3013bc9ec63a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="fontconfig, freetype, libc++, libjpeg-turbo, libpng, libtiff, libxml2, openssl, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DPODOFO_BUILD_LIB_ONLY=TRUE
-DPODOFO_BUILD_STATIC=FALSE
"
