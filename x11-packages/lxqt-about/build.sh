TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="LXQt dialog showing information about LXQt and the system"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.2.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/lxqt/lxqt-about/releases/download/${TERMUX_PKG_VERSION}/lxqt-about-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=c5cb4eaa1c05be347a920dcc97c7892499d483e7e776b4633e390b67c16cd76f
TERMUX_PKG_DEPENDS="libc++, liblxqt, libqtxdg, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt6-qttools"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DQt6LinguistTools_DIR=${TERMUX_PREFIX}/opt/qt6/cross/lib/cmake/Qt6LinguistTools"
	fi
}
