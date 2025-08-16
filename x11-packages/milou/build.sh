TERMUX_PKG_HOMEPAGE="https://invent.kde.org/plasma/milou"
TERMUX_PKG_DESCRIPTION="A dedicated search application built on top of Baloo"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.5.1"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/plasma/${TERMUX_PKG_VERSION}/milou-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="bed9579edc5cbe3702a8d6641920f4ec03605f1e8d4f23c78b1835f07ce77134"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kconfig, kf6-kirigami, kf6-krunner, libc++, libplasma, qt6-qtbase, qt6-qtdeclarative"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
