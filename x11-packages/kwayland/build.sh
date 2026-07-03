TERMUX_PKG_HOMEPAGE="https://invent.kde.org/plasma/kwayland"
TERMUX_PKG_DESCRIPTION="Qt-style Client and Server library wrapper for Wayland libraries"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.7.2"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/plasma/${TERMUX_PKG_VERSION}/kwayland-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=3d3ca745d4f7a53be8b331fccde825d9cc54a8761d7a33318f4fb2d602b857f4
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libwayland, qt6-qtbase, qt6-qtwayland"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, libwayland-protocols, plasma-wayland-protocols, qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
