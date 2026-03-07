TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="LXQt power management daemon"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.3.0"
TERMUX_PKG_SRCURL="https://github.com/lxqt/lxqt-powermanagement/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256="a816d8bca81677487d9b9cc5d8ff85cc2c646accba26a83d0a48ad559dad4a2e"
TERMUX_PKG_DEPENDS="hicolor-icon-theme, kf6-kidletime, kf6-solid, libc++, lxqt-globalkeys, qt6-qtsvg, upower"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DQt6LinguistTools_DIR=${TERMUX_PREFIX}/opt/qt6/cross/lib/cmake/Qt6LinguistTools"
	fi
}
