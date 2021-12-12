TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="Library providing components to build desktop file managers"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
TERMUX_PKG_VERSION=0.17.1
TERMUX_PKG_REVISION=6
TERMUX_PKG_SRCURL="https://github.com/lxqt/libfm-qt/releases/download/${TERMUX_PKG_VERSION}/libfm-qt-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=aa3f8f4d8035d106ed80e0b0ae5fced5ad61d4dac3f960392f3a71fb42a521a5
TERMUX_PKG_DEPENDS="qt5-qtbase, qt5-qtx11extras, glib, libxcb, libexif, menu-cache"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt5-qtbase-cross-tools, qt5-qttools-cross-tools"

