TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="Library providing components to build desktop file managers"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.4.0"
TERMUX_PKG_SRCURL="https://github.com/lxqt/libfm-qt/releases/download/${TERMUX_PKG_VERSION}/libfm-qt-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=2ee3882e023df1df31a53f03575856d38364aa63bec39e9a47fde3730d6f7753
TERMUX_PKG_DEPENDS="libc++, qt5-qtbase, qt5-qtx11extras, glib, libxcb, libexif, lxqt-menu-data, menu-cache"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt5-qtbase-cross-tools, qt5-qttools-cross-tools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DGLIB_GIO_UNIX_INCLUDE_DIR=$TERMUX_PREFIX/include/gio-unix-2.0
"
