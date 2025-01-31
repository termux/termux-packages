TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="LXQt Image Viewer"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.1.1"
TERMUX_PKG_SRCURL="https://github.com/lxqt/lximage-qt/releases/download/${TERMUX_PKG_VERSION}/lximage-qt-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=985f709e91976b29102170b6e015c1517a418908efec8d0700daab06ee2e1b06
TERMUX_PKG_DEPENDS="glib, libc++, libexif, libfm-qt, libx11, libxfixes, qt6-qtbase, qt6-qtsvg"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt6-qttools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DQt6LinguistTools_DIR=${TERMUX_PREFIX}/opt/qt6/cross/lib/cmake/Qt6LinguistTools
"
