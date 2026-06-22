TERMUX_PKG_HOMEPAGE=https://nextcloud.com/
TERMUX_PKG_DESCRIPTION="Command-line client tool for Nextcloud."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="33.0.6"
TERMUX_PKG_SRCURL="https://github.com/nextcloud/desktop/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=eceb6cf205c6946768d0d5e4b45e7ce8905407c3799437f03f7688656a6a0f3d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="dbus, dbus-glib, libc++, libp11, openssl, qtkeychain, qt6-qtbase, inotify-tools, libsqlite, kdsingleapplication, kf6-karchive, qt6-qtwebsockets, qt6-qtsvg, qt6-qt5compat"
TERMUX_PKG_BUILD_DEPENDS="qt6-qtbase-cross-tools, qt6-qttools-cross-tools, pkg-config, qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_GUI=OFF
-DBUILD_SHELL_INTEGRATION=OFF
-DBUILD_WITH_WEBENGINE=OFF
-DBUILD_UPDATER=OFF
-DTOKEN_AUTH_ONLY=OFF
-DBUILD_TESTING=OFF
"
