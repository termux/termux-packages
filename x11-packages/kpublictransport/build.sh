TERMUX_PKG_HOMEPAGE="https://invent.kde.org/libraries/kpublictransport"
TERMUX_PKG_DESCRIPTION="Library to assist with accessing public transport timetables and other data"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.08.3"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kpublictransport-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=603ad9793eb63151ac08d0d32fc1a18bc9cb4a3d5c6d05e41fcf7dd073de47a7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-ki18n, libc++, qt6-qtbase, qt6-qtdeclarative, qt6-qtlocation, qt6-qtpositioning, zlib"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, kirigami-addons, protobuf"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
