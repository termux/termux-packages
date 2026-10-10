TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/kmbox"
TERMUX_PKG_DESCRIPTION="Library for accessing mail storages in MBox format"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.08.2"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kmbox-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=a4b08915584d0b7ec5fa28adae1eb3d0bc63a1d95f15e40bfae529505d0307a5
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kmime, libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
