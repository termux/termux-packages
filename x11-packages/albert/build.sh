TERMUX_PKG_HOMEPAGE=https://albertlauncher.github.io/
TERMUX_PKG_DESCRIPTION="A fast and flexible plugin-based keyboard launcher"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="35.1.0"
# The release tarballs do not contain the git submodules (plugins, QHotkey,
# QNotification, i18n), so a git checkout is required.
TERMUX_PKG_SRCURL="git+https://github.com/albertlauncher/albert"
TERMUX_PKG_GIT_BRANCH="v${TERMUX_PKG_VERSION}"
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="dbus, libarchive, libc++, libx11, libxcb, qalc, qcoro, qt6-qtbase, qt6-qtscxml, qt6-qtsvg, xdg-utils"
TERMUX_PKG_BUILD_DEPENDS="qcoro-static, qt6-qtbase-cross-tools, qt6-qttools, qt6-qttools-cross-tools, xorgproto"

# Plugins disabled because they are macOS-only (contacts, menubar), need
# services that do not exist in Termux (bluetooth: BlueZ, vpn: NetworkManager,
# homebrew) or are not needed here (debug, github, mediaremote, python,
# spotify).
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DBUILD_TESTS=OFF
-DBUILD_PLUGIN_BLUETOOTH=OFF
-DBUILD_PLUGIN_CONTACTS=OFF
-DBUILD_PLUGIN_DEBUG=OFF
-DBUILD_PLUGIN_GITHUB=OFF
-DBUILD_PLUGIN_HOMEBREW=OFF
-DBUILD_PLUGIN_MEDIAREMOTE=OFF
-DBUILD_PLUGIN_MENUBAR=OFF
-DBUILD_PLUGIN_PYTHON=OFF
-DBUILD_PLUGIN_SPOTIFY=OFF
-DBUILD_PLUGIN_VPN=OFF
"
