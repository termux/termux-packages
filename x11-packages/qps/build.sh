TERMUX_PKG_HOMEPAGE=https://github.com/lxqt/qps
TERMUX_PKG_DESCRIPTION="Qt process manager"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.14.0"
TERMUX_PKG_SRCURL="https://github.com/lxqt/qps/releases/download/${TERMUX_PKG_VERSION}/qps-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=a988317c68c177ffb50ae51c1a1fd099ab8f2361763073e1d9b79770e9eb090f
TERMUX_PKG_DEPENDS="libc++, liblxqt, libx11, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt6-qttools-cross-tools"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DQt6LinguistTools_DIR=${TERMUX_PREFIX}/opt/qt6/cross/lib/cmake/Qt6LinguistTools"
	fi
}
