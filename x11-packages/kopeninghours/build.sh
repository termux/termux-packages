TERMUX_PKG_HOMEPAGE="https://invent.kde.org/libraries/kopeninghours"
TERMUX_PKG_DESCRIPTION="Library for parsing and evaluating OSM opening hours expressions"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.04.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kopeninghours-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="dbcb9aa8018fe1b42bab1031b4f76d363aa0872380e125e04649f4ef5f6421ef"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kholidays, kf6-ki18n, libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="boost, extra-cmake-modules, python, qt6-qtdeclarative"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DBUILD_WITH_QT6=ON
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
