TERMUX_PKG_HOMEPAGE=https://www.qt.io/
TERMUX_PKG_DESCRIPTION="Qt XmlPatterns Library"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
TERMUX_PKG_VERSION=5.15.7
TERMUX_PKG_SRCURL="https://download.qt.io/official_releases/qt/5.15/${TERMUX_PKG_VERSION}/submodules/qtxmlpatterns-everywhere-opensource-src-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=b49014963cb83ac32ec720a63a1e3639e714aec545ac75b99100cf1753697413
TERMUX_PKG_DEPENDS="libc++, qt5-qtbase, qt5-qtdeclarative"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_NO_STATICSPLIT=true

termux_step_configure () {
    "${TERMUX_PREFIX}/opt/qt/cross/bin/qmake" \
        -spec "${TERMUX_PREFIX}/lib/qt/mkspecs/termux-cross"
}

termux_step_post_make_install() {
    ## Drop QMAKE_PRL_BUILD_DIR because reference the build dir.
    find "${TERMUX_PREFIX}/lib" -type f -name "libQt5XmlPatterns*.prl" \
        -exec sed -i -e '/^QMAKE_PRL_BUILD_DIR/d' "{}" \;

    ## Remove *.la files.
    find "${TERMUX_PREFIX}/lib" -iname \*.la -delete
}

