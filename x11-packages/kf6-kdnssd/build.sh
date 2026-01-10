TERMUX_PKG_HOMEPAGE="https://invent.kde.org/frameworks/kdnssd"
TERMUX_PKG_DESCRIPTION="Abstraction to system DNSSD features"
TERMUX_PKG_LICENSE="LGPL-2.0-only, LGPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.22.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/kdnssd-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=5bedf0c89cd9d4152580af76dd7db27df8563fef217e8b66c7a1947c1d6295a9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
