TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="A simple & lightweight Qt file archiver"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
TERMUX_PKG_VERSION="0.7.0"
TERMUX_PKG_SRCURL="https://github.com/lxqt/lxqt-archiver/releases/download/${TERMUX_PKG_VERSION}/lxqt-archiver-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=f8cdf398f544d8acdde0571ad7e03836ba3a9a6c66d3f8c907399357399da46d
TERMUX_PKG_DEPENDS="qt5-qtbase, qt5-qtx11extras, libfm-qt, glib, json-glib"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt5-qtbase-cross-tools, qt5-qttools-cross-tools"
TERMUX_PKG_AUTO_UPDATE=true

