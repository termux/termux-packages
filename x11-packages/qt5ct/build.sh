TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/qt5ct/
TERMUX_PKG_DESCRIPTION="Qt5 Configuration Tool"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.9"
TERMUX_PKG_SRCURL="https://downloads.sf.net/qt5ct/qt5ct-${TERMUX_PKG_VERSION}.tar.bz2"
TERMUX_PKG_SHA256=dc10e6939d423b925981ce67febb1a015b6f61c022a9cc7e6c8b5efea4588bff
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, qt5-qtbase"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools, qt5-qttools-cross-tools"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_NO_STATICSPLIT=true

termux_step_configure () {
	"${TERMUX_PREFIX}/opt/qt/cross/bin/qmake" \
		-spec "${TERMUX_PREFIX}/lib/qt/mkspecs/termux-cross" \
		PREFIX="${TERMUX_PREFIX}"
}
