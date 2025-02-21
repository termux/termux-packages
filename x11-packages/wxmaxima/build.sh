TERMUX_PKG_HOMEPAGE=https://wxmaxima-developers.github.io/wxmaxima/
TERMUX_PKG_DESCRIPTION="A document based interface for the computer algebra system Maxima"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.01.0"
TERMUX_PKG_SRCURL=https://github.com/wxMaxima-developers/wxmaxima/archive/refs/tags/Version-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=18cce36cc6c41ca012ec128aafe3c96659b1d670f8a8f7d98395eac1a19ade6f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_SED_REGEXP='s/.*-//'
TERMUX_PKG_DEPENDS="libc++, maxima, wxwidgets"
TERMUX_PKG_BLACKLISTED_ARCHES="i686, x86_64"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DwxWidgets_CONFIG_EXECUTABLE=$TERMUX_PREFIX/bin/wx-config
-DWXM_INCLUDE_FONTS=OFF
-DWXM_UNIT_TESTS=OFF
"
