TERMUX_PKG_HOMEPAGE="https://invent.kde.org/libraries/kweathercore"
TERMUX_PKG_DESCRIPTION="Library to facilitate retrieval of weather information including forecasts and alerts"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.04.2"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kweathercore-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=d370b4581983597b16a383fc67206118c8f6a67f0f5d6421e97dd6b7695a60d9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kholidays, kf6-ki18n, libc++, qt6-qtbase, qt6-qtpositioning"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qtdeclarative"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
" 
