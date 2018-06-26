TERMUX_PKG_HOMEPAGE=http://www.libpng.org/pub/png/libpng.html
TERMUX_PKG_DESCRIPTION="Official PNG reference library"
TERMUX_PKG_VERSION=1.6.34
TERMUX_PKG_SHA256=2f1e960d92ce3b3abd03d06dfec9637dfbd22febf107a536b44f7a47c60659f6
TERMUX_PKG_SRCURL=https://fossies.org/linux/misc/libpng-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_INCLUDE_IN_DEVPACKAGE="bin/libpng-config bin/libpng16-config"
TERMUX_PKG_RM_AFTER_INSTALL="bin/png-fix-itxt bin/pngfix"
