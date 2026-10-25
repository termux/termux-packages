TERMUX_PKG_HOMEPAGE=http://www.libpng.org/pub/png/libpng.html
TERMUX_PKG_DESCRIPTION="Official PNG reference library"
TERMUX_PKG_LICENSE="Libpng"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.6.59"
TERMUX_PKG_SRCURL="https://github.com/pnggroup/libpng/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=2540302a1844ad2b2b501977abecfa850f265f97b78f065a712ab4074a89f5b5
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP='(?<=^v)\d+\.\d+\.\d+$'
TERMUX_PKG_DEPENDS="zlib"
TERMUX_PKG_BREAKS="libpng-dev"
TERMUX_PKG_REPLACES="libpng-dev"
TERMUX_PKG_RM_AFTER_INSTALL="bin/png-fix-itxt bin/pngfix"
