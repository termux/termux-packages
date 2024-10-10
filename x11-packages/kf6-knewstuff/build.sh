TERMUX_PKG_HOMEPAGE='https://community.kde.org/Frameworks'
TERMUX_PKG_DESCRIPTION='Support for downloading application assets from the network'
TERMUX_PKG_LICENSE="LGPL-2.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=6.6.0
TERMUX_PKG_SRCURL=https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/knewstuff-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=3f927564b454c1fc1aeec05174b8f9e76303b4d9a45979d76b2188a25bd47025
TERMUX_PKG_DEPENDS="kf6-attica, kf6-karchive, kf6-kconfig, kf6-kcoreaddons, kf6-ki18n, kf6-kpackage, kf6-kwidgetsaddons, qt6-qtbase, kf6-syndication"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, kf6-kirigami, qt6-qtdeclarative, qt6-qttools"
TERMUX_PKG_RECOMMENDS="kf6-kirigami, qt6-qtdeclarative"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
"
