TERMUX_PKG_HOMEPAGE="https://invent.kde.org/libraries/baloo-widgets"
TERMUX_PKG_DESCRIPTION="Widgets for Baloo"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.04.3"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/baloo-widgets-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=fa5288d216d3ed9ed0926385dbc0b266b60317a60c231a6dccaff4bcd810d9fc
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-baloo, kf6-kconfig, kf6-kcoreaddons, kf6-kfilemetadata, kf6-ki18n, kf6-kio, kf6-kservice, kf6-kwidgetsaddons, libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
