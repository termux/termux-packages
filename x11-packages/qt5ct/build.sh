TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/qt5ct
TERMUX_PKG_DESCRIPTION="Qt5 Configuration Tool"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
TERMUX_PKG_VERSION=1.3
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://downloads.sf.net/qt5ct/qt5ct-${TERMUX_PKG_VERSION}.tar.bz2"
TERMUX_PKG_SHA256=dd443b14e590aff76a16e1316d56e688882e3248c470df4f71bc952569f3c3bc
TERMUX_PKG_DEPENDS="qt5-qtbase, qt5-qtsvg"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools, qt5-qttools-cross-tools"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_NO_STATICSPLIT=true

termux_step_configure () {
    "${TERMUX_PREFIX}/opt/qt/cross/bin/qmake" \
        -spec "${TERMUX_PREFIX}/lib/qt/mkspecs/termux-cross" \
        PREFIX="${TERMUX_PREFIX}"
}

