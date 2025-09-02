TERMUX_PKG_HOMEPAGE="https://invent.kde.org/plasma/libkscreen"
TERMUX_PKG_DESCRIPTION="KDE screen management software"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.4.5"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/plasma/${TERMUX_PKG_VERSION}/libkscreen-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="68d26e27656b450f15a78f44784c50a22034e57c14f96a402019d52bc5b3e2b4"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libwayland, libxcb, qt6-qtbase, qt6-qtwayland"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, plasma-wayland-protocols, qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
