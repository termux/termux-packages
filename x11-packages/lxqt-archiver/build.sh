TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="A simple & lightweight Qt file archiver"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.3.0"
TERMUX_PKG_SRCURL="https://github.com/lxqt/lxqt-archiver/releases/download/${TERMUX_PKG_VERSION}/lxqt-archiver-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=8efd3236b0118808de0a686744cad48a705b14f00efc9794866b4691b49462f9
TERMUX_PKG_DEPENDS="glib, json-glib, libc++, libfm-qt, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt6-qttools"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DQt6LinguistTools_DIR=${TERMUX_PREFIX}/opt/qt6/cross/lib/cmake/Qt6LinguistTools"
	fi
}
