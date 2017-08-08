TERMUX_PKG_HOMEPAGE=http://www.libpng.org/pub/png/libpng.html
TERMUX_PKG_DESCRIPTION="Official PNG reference library"
TERMUX_PKG_VERSION=1.6.31
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/libpng/libpng16/${TERMUX_PKG_VERSION}/libpng-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=232a602de04916b2b5ce6f901829caf419519e6a16cc9cd7c1c91187d3ee8b41
TERMUX_PKG_INCLUDE_IN_DEVPACKAGE="bin/libpng-config bin/libpng16-config"
TERMUX_PKG_RM_AFTER_INSTALL="bin/png-fix-itxt bin/pngfix"
