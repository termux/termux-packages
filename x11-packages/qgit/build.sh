TERMUX_PKG_HOMEPAGE=https://github.com/tibirna/qgit
TERMUX_PKG_DESCRIPTION="A git GUI viewer"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.9
TERMUX_PKG_REVISION=22
TERMUX_PKG_SRCURL=https://github.com/tibirna/qgit/archive/qgit-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=69788efda7d434d1bc094bb414bd92c269dc7894326320634500b05d63c008e8
TERMUX_PKG_DEPENDS="git, hicolor-icon-theme, qt5-qtbase"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
    "${TERMUX_PREFIX}/opt/qt/cross/bin/qmake" \
        -spec "${TERMUX_PREFIX}/lib/qt/mkspecs/termux-cross"
}
