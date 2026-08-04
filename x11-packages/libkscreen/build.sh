TERMUX_PKG_HOMEPAGE="https://invent.kde.org/plasma/libkscreen"
TERMUX_PKG_DESCRIPTION="KDE screen management software"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.7.4"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/plasma/${TERMUX_PKG_VERSION}/libkscreen-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=f40bfbd83147a7c7ff387ffe5053cc2ea000bdb21555a0b3d06da3c59d7b4977
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libwayland, libxcb, qt6-qtbase, qt6-qtwayland"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, plasma-wayland-protocols, qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
