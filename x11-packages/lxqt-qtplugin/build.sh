TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="LXQt platform integration plugin for Qt 5"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
TERMUX_PKG_VERSION=0.17.0
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL="https://github.com/lxqt/lxqt-qtplugin/releases/download/${TERMUX_PKG_VERSION}/lxqt-qtplugin-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=65ef1156eb3257bd875e944963968585b042262d6b673ec6506d8fe7fa528691
TERMUX_PKG_DEPENDS="qt5-qtbase, kwindowsystem, libqtxdg, libfm-qt, libexif, libdbusmenu-qt"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt5-qtbase-cross-tools, qt5-qttools-cross-tools"

