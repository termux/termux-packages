TERMUX_PKG_HOMEPAGE=http://www.libpng.org/pub/png/libpng.html
TERMUX_PKG_DESCRIPTION="Official PNG reference library"
TERMUX_PKG_VERSION=1.6.32
TERMUX_PKG_SHA256=c918c3113de74a692f0a1526ce881dc26067763eb3915c57ef3a0f7b6886f59b
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/libpng/libpng16/${TERMUX_PKG_VERSION}/libpng-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_INCLUDE_IN_DEVPACKAGE="bin/libpng-config bin/libpng16-config"
TERMUX_PKG_RM_AFTER_INSTALL="bin/png-fix-itxt bin/pngfix"
