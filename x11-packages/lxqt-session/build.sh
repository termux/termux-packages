TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="The LXQt session manager"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.0.0"
TERMUX_PKG_SRCURL="https://github.com/lxqt/lxqt-session/releases/download/${TERMUX_PKG_VERSION}/lxqt-session-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=74ea3b998fecb50834b8b09952c31a1bf128fde9f7cfdd31284f7397665cb428
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kwindowsystem, layer-shell-qt, libandroid-wordexp, libc++, liblxqt, libqtxdg, libx11, procps, qt6-qtbase, qtxdg-tools"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DWITH_LIBUDEV=OFF
-DQt6LinguistTools_DIR=${TERMUX_PREFIX}/opt/qt6/cross/lib/cmake/Qt6LinguistTools
"

termux_step_pre_configure(){
	LDFLAGS+=" -landroid-wordexp"
}
