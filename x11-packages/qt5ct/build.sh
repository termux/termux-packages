TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/qt5ct
TERMUX_PKG_DESCRIPTION="Qt5 Configuration Tool"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
TERMUX_PKG_VERSION=1.7
TERMUX_PKG_SRCURL="https://downloads.sf.net/qt5ct/qt5ct-${TERMUX_PKG_VERSION}.tar.bz2"
TERMUX_PKG_SHA256=ed58546a6e4c50dfed1b9ff6a148d4a468fe9b4d7b5b2727b96501de2955b8d7
TERMUX_PKG_DEPENDS="libc++, qt5-qtbase"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools, qt5-qttools-cross-tools"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_NO_STATICSPLIT=true

termux_step_configure () {
    "${TERMUX_PREFIX}/opt/qt/cross/bin/qmake" \
        -spec "${TERMUX_PREFIX}/lib/qt/mkspecs/termux-cross" \
        PREFIX="${TERMUX_PREFIX}"
}

