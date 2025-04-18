TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="LXQt platform integration plugin for Qt"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.2.0"
TERMUX_PKG_SRCURL="https://github.com/lxqt/lxqt-qtplugin/releases/download/${TERMUX_PKG_VERSION}/lxqt-qtplugin-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=e03a0f03e0a4bdc059e72d4c9c5f8e5387d7778cd85b9d53fc7bb8c4403805f0
TERMUX_PKG_DEPENDS="libc++, libdbusmenu-lxqt, libfm-qt, libqtxdg, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt6-qttools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-D_QT_PLUGINS_DIR=${TERMUX_PREFIX}/lib/qt6/plugins
"
