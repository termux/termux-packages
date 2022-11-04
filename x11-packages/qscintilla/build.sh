TERMUX_PKG_HOMEPAGE=https://riverbankcomputing.com/software/qscintilla
TERMUX_PKG_DESCRIPTION="QScintilla is a port to Qt of the Scintilla editing component"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
TERMUX_PKG_VERSION=2.13.3
TERMUX_PKG_SRCURL="https://www.riverbankcomputing.com/static/Downloads/QScintilla/${TERMUX_PKG_VERSION}/QScintilla_src-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=711d28e37c8fccaa8229e8e39a5b3b2d97f3fffc63da10b71c71b84fa3649398
TERMUX_PKG_DEPENDS="libc++, qt5-qtbase"
# qttools is only needed to build Qt Designer's plugins
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools, qt5-qttools"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_EXTRA_MAKE_ARGS="-C src"

termux_step_configure () {
    for i in src designer; do
        cd "${TERMUX_PKG_SRCDIR}/${i}" && {
            "${TERMUX_PREFIX}/opt/qt/cross/bin/qmake" \
                -spec "${TERMUX_PREFIX}/lib/qt/mkspecs/termux-cross"
        }
    done
    unset i
}

termux_step_post_make_install() {
    cd "${TERMUX_PKG_SRCDIR}/designer" && {
        make -j "${TERMUX_MAKE_PROCESSES}"
        make install
    }
}

