TERMUX_PKG_HOMEPAGE="https://invent.kde.org/libraries/baloo-widgets"
TERMUX_PKG_DESCRIPTION="Widgets for Baloo"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.04.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/baloo-widgets-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=aa3f15c66d5bdf46c1fb66d8fb2f4c7693f2b3ba46a8fe56a3c193fc9e92d6d3
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-baloo, kf6-kconfig, kf6-kcoreaddons, kf6-kfilemetadata, kf6-ki18n, kf6-kio, kf6-kservice, kf6-kwidgetsaddons, libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
