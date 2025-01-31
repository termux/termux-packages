TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="LXQt application launcher"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.1.2"
TERMUX_PKG_SRCURL="https://github.com/lxqt/lxqt-runner/releases/download/${TERMUX_PKG_VERSION}/lxqt-runner-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=9d95ab07e57102c696b72be772c169c6ae260b04177cbc336e75e7578a4b2de2
TERMUX_PKG_DEPENDS="kf6-kwindowsystem, layer-shell-qt, libc++, liblxqt, libmuparser, lxqt-globalkeys, libqtxdg, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt6-qttools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DQt6LinguistTools_DIR=${TERMUX_PREFIX}/opt/qt6/cross/lib/cmake/Qt6LinguistTools
"
