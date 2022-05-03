TERMUX_PKG_HOMEPAGE=https://github.com/Swordfish90/cool-retro-term
TERMUX_PKG_DESCRIPTION="A terminal emulator which mimics the look and feel of the old cathode tube screens"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.2.0
TERMUX_PKG_SRCURL=https://github.com/Swordfish90/cool-retro-term.git
TERMUX_PKG_GIT_BRANCH=${TERMUX_PKG_VERSION}
TERMUX_PKG_DEPENDS="qt5-qtbase, qt5-qtdeclarative, qt5-qtquickcontrols2"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools, qt5-qtdeclarative-cross-tools"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	"${TERMUX_PREFIX}/opt/qt/cross/bin/qmake" \
		-spec "${TERMUX_PREFIX}/lib/qt/mkspecs/termux-cross" \
		${TERMUX_PKG_EXTRA_CONFIGURE_ARGS}
}
