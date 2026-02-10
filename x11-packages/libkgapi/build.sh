TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/libkgapi"
TERMUX_PKG_DESCRIPTION="A KDE-based library for accessing various Google services via their public API"
TERMUX_PKG_LICENSE="GPL-2.0-or-later, LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.12.2"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/libkgapi-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="42086c3f5cec31be3c379b43ae80e32beb29055159d1670e00ad7f0892632c1c"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kcalendarcore, kf6-kcontacts, kf6-kwallet, libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
