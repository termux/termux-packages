TERMUX_PKG_HOMEPAGE='https://community.kde.org/Frameworks'
TERMUX_PKG_DESCRIPTION='Hardware integration and detection'
TERMUX_PKG_LICENSE="LGPL-2.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.11.0"
TERMUX_PKG_SRCURL=https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/solid-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=cdecc7665b801a508b9ad0929b025ac93fe287be503589c8d8c38a520c2508d7
TERMUX_PKG_DEPENDS="libimobiledevice, libplist, qt6-qtbase, libc++, util-linux"
# media-player-info, systemd-libs, udisks2, upower can be added to TERMUX_PKG_DEPENDS when available
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules (>= ${TERMUX_PKG_VERSION}), qt6-qtdeclarative, qt6-qttools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
