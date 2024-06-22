TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="Qt 5 implementation of freedesktop.org XDG specifications"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.12.0"
TERMUX_PKG_SRCURL="https://github.com/lxqt/libqtxdg/releases/download/${TERMUX_PKG_VERSION}/libqtxdg-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=726856ff447220575c84461800b151328e784c6c326a5065ef3f9a7f9506d4dc
TERMUX_PKG_DEPENDS="libc++, qt5-qtbase, qt5-qtsvg, glib"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt5-qttools-cross-tools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DGLIB_GIO_UNIX_INCLUDE_DIR=$TERMUX_PREFIX/include/gio-unix-2.0
"
TERMUX_PKG_AUTO_UPDATE=true
