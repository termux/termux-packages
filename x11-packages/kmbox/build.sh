TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/kmbox"
TERMUX_PKG_DESCRIPTION="Library for accessing mail storages in MBox format"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.04.2"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kmbox-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="27e796610b7e7a2249b4673fd8a27b59c92d5a6fe1a9af9e35ecd6308cde8f15"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kmime, libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
