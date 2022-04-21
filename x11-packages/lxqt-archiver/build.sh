TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="A simple & lightweight Qt file archiver"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
TERMUX_PKG_VERSION="0.6.0"
TERMUX_PKG_SRCURL="https://github.com/lxqt/lxqt-archiver/releases/download/${TERMUX_PKG_VERSION}/lxqt-archiver-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=80f11715452438eae8dde8e37169e082b3ff8e484c5d71449c025277f3c9bdb3
TERMUX_PKG_DEPENDS="qt5-qtbase, qt5-qtx11extras, libfm-qt, glib, json-glib"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt5-qtbase-cross-tools, qt5-qttools-cross-tools"
TERMUX_PKG_AUTO_UPDATE=true

