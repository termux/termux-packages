TERMUX_PKG_HOMEPAGE="https://invent.kde.org/plasma/libksysguard"
TERMUX_PKG_DESCRIPTION="KSysGuard library provides API to read and manage processes running on the system"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.6.4"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/plasma/${TERMUX_PKG_VERSION}/libksysguard-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=9dd0a5a8d3f12d65351fab8c132365dd65f0f9976d6831598ce30ebbfa291a89
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kauth, kf6-kconfig, kf6-kcoreaddons, kf6-kdeclarative, kf6-ki18n, kf6-kirigami, kf6-kitemmodels, kf6-knewstuff, kf6-kpackage, kf6-kquickcharts, kf6-kservice, kf6-solid, libc++, libdrm, libnl, libpcap, qt6-qt5compat, qt6-qtbase, qt6-qtdeclarative"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
-DCMAKE_CXX_FLAGS="-fexperimental-library"
"
