TERMUX_PKG_HOMEPAGE=http://www.libpng.org/pub/png/libpng.html
TERMUX_PKG_DESCRIPTION="Official PNG reference library"
TERMUX_PKG_VERSION=1.6.35
TERMUX_PKG_SHA256=23912ec8c9584917ed9b09c5023465d71709dce089be503c7867fec68a93bcd7
TERMUX_PKG_SRCURL=https://fossies.org/linux/misc/libpng-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_INCLUDE_IN_DEVPACKAGE="bin/libpng-config bin/libpng16-config"
TERMUX_PKG_RM_AFTER_INSTALL="bin/png-fix-itxt bin/pngfix"
