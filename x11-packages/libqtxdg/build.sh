TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="Qt implementation of freedesktop.org XDG specifications"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.3.0"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL="https://github.com/lxqt/libqtxdg/releases/download/${TERMUX_PKG_VERSION}/libqtxdg-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=846cb8a35ab55ea3d513a860b6bb5fdf45e2de95a037afb73538b316908efa55
TERMUX_PKG_DEPENDS="libc++, qt6-qtbase, qt6-qtsvg, glib"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt6-qttools"
TERMUX_PKG_AUTO_UPDATE=true
# See plugin path in libqtxdg/src/xdgiconloader/plugin/CMakeLists.txt
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DQTXDGX_ICONENGINEPLUGIN_INSTALL_PATH=${TERMUX_PREFIX}/lib/qt6/plugins/iconengines
"
