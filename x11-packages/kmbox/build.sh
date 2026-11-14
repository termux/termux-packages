TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/kmbox"
TERMUX_PKG_DESCRIPTION="Library for accessing mail storages in MBox format"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.08.3"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kmbox-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=b897e2c360b2b2e0d34ab196cef4c9e840920e6001df73538fa05407c4270bad
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kmime, libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
