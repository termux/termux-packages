TERMUX_PKG_HOMEPAGE="https://invent.kde.org/frameworks/kdnssd"
TERMUX_PKG_DESCRIPTION="Abstraction to system DNSSD features"
TERMUX_PKG_LICENSE="LGPL-2.0-only, LGPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.21.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/kdnssd-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="73d72c92f3049133f0fecbbc5b802440cc62dd16f8eccc8b2cc47cdd0b705729"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
