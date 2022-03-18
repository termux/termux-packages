TERMUX_PKG_HOMEPAGE=https://www.qt.io/
TERMUX_PKG_DESCRIPTION="Qt Quick Controls module"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
TERMUX_PKG_VERSION=5.15.3
TERMUX_PKG_SRCURL="https://download.qt.io/official_releases/qt/${TERMUX_PKG_VERSION%.*}/${TERMUX_PKG_VERSION}/submodules/${TERMUX_PKG_NAME#qt5-}-everywhere-opensource-src-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=4034afce2e8afde4c4cb5e3be3ce240d00647fa0d292f4cd1ac4454ce40230f0
TERMUX_PKG_DEPENDS="qt5-qtbase, qt5-qtdeclarative"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_NO_STATICSPLIT=true

termux_step_configure () {
    "${TERMUX_PREFIX}/opt/qt/cross/bin/qmake" \
        -spec "${TERMUX_PREFIX}/lib/qt/mkspecs/termux-cross"
}

termux_step_post_make_install() {
    #######################################################
    ##
    ##  Fixes & cleanup.
    ##
    #######################################################

    ## Remove *.la files.
    find "${TERMUX_PREFIX}/lib" -iname \*.la -delete
}

