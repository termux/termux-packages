TERMUX_PKG_HOMEPAGE="https://invent.kde.org/plasma/kwayland"
TERMUX_PKG_DESCRIPTION="Qt-style Client and Server library wrapper for Wayland libraries"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.5.1"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/plasma/${TERMUX_PKG_VERSION}/kwayland-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="5622ee2517ec80e9dc60203e04b5adbabd0ceaddfcd282c44b8542644b808767"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libwayland, qt6-qtbase, qt6-qtwayland"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, libwayland-protocols, plasma-wayland-protocols, qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
