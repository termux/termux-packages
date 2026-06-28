TERMUX_PKG_HOMEPAGE=https://nheko.im/nheko-reborn/qt-jdenticon
TERMUX_PKG_DESCRIPTION="Qt5 / C++14 Port of Jdenticon"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.3.0"
TERMUX_PKG_SRCURL="https://nheko.im/nheko-reborn/qt-jdenticon/-/archive/v${TERMUX_PKG_VERSION}/qt-jdenticon-v${TERMUX_PKG_VERSION}.tar.bz2"
TERMUX_PKG_SHA256=c10052055af373cb60ef67ad748a0b525b57577767288c6dac6dbb68816d1d07
TERMUX_PKG_DEPENDS="libc++, libglvnd, qt5-qtbase"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
PREFIX=${TERMUX_PREFIX}
"

termux_step_configure() {
	"${TERMUX_PREFIX}/opt/qt/cross/bin/qmake" \
		-spec "${TERMUX_PREFIX}/lib/qt/mkspecs/termux-cross" \
		${TERMUX_PKG_EXTRA_CONFIGURE_ARGS}
}
