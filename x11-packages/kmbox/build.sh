TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/kmbox"
TERMUX_PKG_DESCRIPTION="Library for accessing mail storages in MBox format"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.12.2"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kmbox-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="c175d4cf3ece8cfd86a6769f48359dc55363973a22d0ce5c0ebaf4de533ce32e"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kmime, libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
