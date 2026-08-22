TERMUX_PKG_HOMEPAGE="https://invent.kde.org/libraries/kosmindoormap"
TERMUX_PKG_DESCRIPTION="OSM multi-floor indoor map renderer"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.08.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kosmindoormap-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=c37e3f537f12964f3aeecc9e2acf7e59618afc230a3c69ca02d53507099f7761
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="abseil-cpp, kf6-kcontacts, kf6-kcoreaddons, kf6-ki18n, kf6-kirigami, kf6-kservice, kirigami-addons, kopeninghours, kpublictransport, libc++, protobuf, qt6-qtbase, qt6-qtdeclarative, recastnavigation, zlib"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, python"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
