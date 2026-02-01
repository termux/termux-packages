TERMUX_PKG_HOMEPAGE="https://invent.kde.org/plasma/kdecoration"
TERMUX_PKG_DESCRIPTION="Plugin-based library to create window decorations"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.5.5"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/plasma/${TERMUX_PKG_VERSION}/kdecoration-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="dc217bc6374f07a427b6d78de677b1878e9af47352c6addeb89426211b53681a"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-ki18n, libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
