TERMUX_PKG_HOMEPAGE="https://invent.kde.org/libraries/kosmindoormap"
TERMUX_PKG_DESCRIPTION="OSM multi-floor indoor map renderer"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.04.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kosmindoormap-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="6d8910de90b11fd519aeab7a7794a4e688d47f127f239a642cfe155efde4c6c0"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="abseil-cpp, kf6-kcontacts, kf6-kcoreaddons, kf6-ki18n, kf6-kirigami, kf6-kservice, kirigami-addons, kopeninghours, kpublictransport, libc++, protobuf, qt6-qtbase, qt6-qtdeclarative, recastnavigation, zlib"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, python"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
