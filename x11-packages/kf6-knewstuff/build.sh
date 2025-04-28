TERMUX_PKG_HOMEPAGE='https://community.kde.org/Frameworks'
TERMUX_PKG_DESCRIPTION='Support for downloading application assets from the network'
TERMUX_PKG_LICENSE="LGPL-2.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.13.0"
TERMUX_PKG_SRCURL=https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/knewstuff-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=338873ceca0593f03a760732e4f8d0fd1bb059f21b7dedcde13f5e594226d798
TERMUX_PKG_DEPENDS="kf6-attica (>= ${TERMUX_PKG_VERSION}), kf6-karchive (>= ${TERMUX_PKG_VERSION}), kf6-kconfig (>= ${TERMUX_PKG_VERSION}), kf6-kcoreaddons (>= ${TERMUX_PKG_VERSION}), kf6-ki18n (>= ${TERMUX_PKG_VERSION}), kf6-kpackage (>= ${TERMUX_PKG_VERSION}), kf6-kwidgetsaddons (>= ${TERMUX_PKG_VERSION}), kf6-syndication (>= ${TERMUX_PKG_VERSION}), libc++, qt6-qtbase, qt6-qtdeclarative"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules (>= ${TERMUX_PKG_VERSION}), kf6-kirigami (>= ${TERMUX_PKG_VERSION}), qt6-qttools"
TERMUX_PKG_RECOMMENDS="kf6-kirigami"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_AUTO_UPDATE_GROUP=x11/kframeworks6
TERMUX_PKG_ALIGN_VERSION_WITH=kf6-kconfig
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
