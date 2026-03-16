TERMUX_PKG_HOMEPAGE="https://invent.kde.org/libraries/kpublictransport"
TERMUX_PKG_DESCRIPTION="Library to assist with accessing public transport timetables and other data"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.04.3"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kpublictransport-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="aeac3ec0fa39a26cf9bacd87a30f5d8cf2968116ca99902873499b6cd45f9b17"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-ki18n, libc++, qt6-qtbase, qt6-qtdeclarative, qt6-qtlocation, qt6-qtpositioning, zlib"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, kirigami-addons, protobuf"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
