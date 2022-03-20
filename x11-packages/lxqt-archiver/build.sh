TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="A simple & lightweight Qt file archiver"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
TERMUX_PKG_VERSION=0.5.0
TERMUX_PKG_SRCURL="https://github.com/lxqt/lxqt-archiver/releases/download/${TERMUX_PKG_VERSION}/lxqt-archiver-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=8ae5259ec00761b1f178e54b9e99bcf64685a6000a148501c4bbe862b4b08fc7
TERMUX_PKG_DEPENDS="qt5-qtbase, qt5-qtx11extras, libfm-qt, glib, json-glib"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt5-qtbase-cross-tools, qt5-qttools-cross-tools"

