TERMUX_PKG_HOMEPAGE=https://www.qt.io/
TERMUX_PKG_DESCRIPTION="Qt X11 Extras enables the Qt programmer to write applications for the Linux/X11 platform"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
TERMUX_PKG_VERSION=5.15.7
TERMUX_PKG_SRCURL="https://download.qt.io/official_releases/qt/5.15/${TERMUX_PKG_VERSION}/submodules/qtx11extras-everywhere-opensource-src-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=21409d44c0b66336097316d210b102efce63ca782ab426223d652502890ac5b4
TERMUX_PKG_DEPENDS="qt5-qtbase"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_NO_STATICSPLIT=true

# Replacing the old qt5-base packages
TERMUX_PKG_REPLACES="qt5-x11extras"

termux_step_configure () {
    "${TERMUX_PREFIX}/opt/qt/cross/bin/qmake" \
        -spec "${TERMUX_PREFIX}/lib/qt/mkspecs/termux-cross"
}

termux_step_make_install() {
    make install

    #######################################################
    ##
    ##  Fixes & cleanup.
    ##
    #######################################################

    ## Drop QMAKE_PRL_BUILD_DIR because reference the build dir.
    find "${TERMUX_PREFIX}/lib" -type f -name "libQt5X11*.prl" \
        -exec sed -i -e '/^QMAKE_PRL_BUILD_DIR/d' "{}" \;

    ## Remove *.la files.
    find "${TERMUX_PREFIX}/lib" -iname \*.la -delete
}

