TERMUX_PKG_HOMEPAGE=https://wxmaxima-developers.github.io/wxmaxima/
TERMUX_PKG_DESCRIPTION="A document based interface for the computer algebra system Maxima"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.04.0"
TERMUX_PKG_SRCURL=https://github.com/wxMaxima-developers/wxmaxima/archive/refs/tags/Version-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ec0b3005c3663f1bb86b0cc5028c2ba121e1563e3d5b671afcb9774895f4191b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_SED_REGEXP='s/.*-//'
TERMUX_PKG_DEPENDS="libc++, maxima, wxwidgets"
TERMUX_PKG_EXCLUDED_ARCHES="i686, x86_64"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DwxWidgets_CONFIG_EXECUTABLE=$TERMUX_PREFIX/bin/wx-config
-DWXM_INCLUDE_FONTS=OFF
-DWXM_UNIT_TESTS=OFF
"
