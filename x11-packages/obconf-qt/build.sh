TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="OpenBox window manager configuration tool"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
TERMUX_PKG_VERSION=0.16.1
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL="https://github.com/lxqt/obconf-qt/releases/download/${TERMUX_PKG_VERSION}/obconf-qt-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=458d96b63dca8a09a4f477d42030d829e8090aae0ea39b3994fcf0b8da8e8b42
TERMUX_PKG_DEPENDS="qt5-qtbase, qt5-qtx11extras, glib, openbox, liblxqt, hicolor-icon-theme"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt5-qtbase-cross-tools, qt5-qttools-cross-tools"

