TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="LXQt platform integration plugin for Qt 5"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_SRCURL="https://github.com/lxqt/lxqt-qtplugin/releases/download/${TERMUX_PKG_VERSION}/lxqt-qtplugin-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=8e789430e1f3b6a354f61d496440a59b797f699320bb8c001d8ef7ac8e1db05e
TERMUX_PKG_DEPENDS="qt5-qtbase, kwindowsystem, libqtxdg, libfm-qt, libexif, libdbusmenu-qt"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt5-qtbase-cross-tools, qt5-qttools-cross-tools"

