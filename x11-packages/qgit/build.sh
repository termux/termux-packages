TERMUX_PKG_HOMEPAGE=https://github.com/tibirna/qgit
TERMUX_PKG_DESCRIPTION="A git GUI viewer"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.11"
TERMUX_PKG_SRCURL=https://github.com/tibirna/qgit/archive/qgit-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1c488a2328030641e3560cb86fb8891d2e8cdc934d910e73a0f19f9c8ee15a7d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_SED_REGEXP='s/.*-//'
TERMUX_PKG_DEPENDS="git, libc++, qt5-qtbase"
TERMUX_PKG_RECOMMENDS="hicolor-icon-theme"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	"${TERMUX_PREFIX}/opt/qt/cross/bin/qmake" \
		-spec "${TERMUX_PREFIX}/lib/qt/mkspecs/termux-cross"
}
