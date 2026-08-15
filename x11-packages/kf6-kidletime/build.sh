TERMUX_PKG_HOMEPAGE="https://invent.kde.org/frameworks/kidletime"
TERMUX_PKG_DESCRIPTION="Reporting of idle time of user and system"
TERMUX_PKG_LICENSE="LGPL-2.0-only, LGPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.29.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/kidletime-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=484002b1da719c72e6b6859422cf0d4351fbb61665aab04c3c2451edc320946b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libx11, libxcb, libxext, libxss, libwayland, qt6-qtbase, qt6-qtwayland"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, libxss, libwayland-protocols, plasma-wayland-protocols, qt6-qttools, qt6-qtwayland"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
