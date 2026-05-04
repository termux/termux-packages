TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="Qt implementation of freedesktop.org XDG specifications"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.4.0"
TERMUX_PKG_SRCURL="https://github.com/lxqt/libqtxdg/releases/download/${TERMUX_PKG_VERSION}/libqtxdg-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=34d25949ae7b6275fb54da46187dd8ba41771600353405b15e53bdc90b9e287a
TERMUX_PKG_DEPENDS="libc++, qt6-qtbase, qt6-qtsvg, glib"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt6-qttools"
TERMUX_PKG_AUTO_UPDATE=true
# See plugin path in libqtxdg/src/xdgiconloader/plugin/CMakeLists.txt
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DQTXDGX_ICONENGINEPLUGIN_INSTALL_PATH=${TERMUX_PREFIX}/lib/qt6/plugins/iconengines
"
