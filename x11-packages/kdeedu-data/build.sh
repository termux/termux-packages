TERMUX_PKG_HOMEPAGE="https://invent.kde.org/education/kdeedu-data"
TERMUX_PKG_DESCRIPTION="Common data for KDE Edu applications"
TERMUX_PKG_LICENSE="GPL-2.0-or-later, LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.08.1"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kdeedu-data-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=df6a0ccadfdade621fe2948de90ae23cc3e25480d61fba8279a06c860398da90
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="hicolor-icon-theme"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qtbase"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
