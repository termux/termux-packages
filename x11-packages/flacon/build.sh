TERMUX_PKG_HOMEPAGE=https://flacon.github.io/
TERMUX_PKG_DESCRIPTION="Extracts individual tracks from one big audio file and saves them as separate audio files"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="12.0.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/flacon/flacon/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=78199ff925b7cd0ffeb628d47909ca4172f8ff0d8fd8192bb537e0c012e6f4c6
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libuchardet, qt6-qtbase, taglib"
TERMUX_PKG_BUILD_DEPENDS="qt6-qtbase-cross-tools, qt6-qttools-cross-tools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DUSE_QT5=OFF -DUSE_QT6=ON"
