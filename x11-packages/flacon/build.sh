TERMUX_PKG_HOMEPAGE=https://flacon.github.io/
TERMUX_PKG_DESCRIPTION="Extracts individual tracks from one big audio file and saves them as separate audio files"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="13.0.2"
TERMUX_PKG_SRCURL=https://github.com/flacon/flacon/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=bbb85061d2ea3736184fd181d09e598278d28e970983cfb0d7b2f809776efd14
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libuchardet, qt6-qtbase, taglib"
TERMUX_PKG_BUILD_DEPENDS="qt6-qtbase-cross-tools, qt6-qttools-cross-tools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DUSE_QT5=OFF -DUSE_QT6=ON"
