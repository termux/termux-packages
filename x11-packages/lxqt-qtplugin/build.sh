TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="LXQt platform integration plugin for Qt 5"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
TERMUX_PKG_VERSION="1.2.0"
TERMUX_PKG_SRCURL="https://github.com/lxqt/lxqt-qtplugin/releases/download/${TERMUX_PKG_VERSION}/lxqt-qtplugin-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=63793501b61f4ff29e65457c8d05c6ab5e15e7a21fc5eb2417f33de71ce98d19
TERMUX_PKG_DEPENDS="libc++, qt5-qtbase, kwindowsystem, libqtxdg, libfm-qt, libexif, libdbusmenu-qt"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt5-qtbase-cross-tools, qt5-qttools-cross-tools"
TERMUX_PKG_AUTO_UPDATE=true

