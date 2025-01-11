TERMUX_PKG_HOMEPAGE='https://community.kde.org/Frameworks'
TERMUX_PKG_DESCRIPTION='Abstraction for system notifications'
TERMUX_PKG_LICENSE="LGPL-2.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.10.0"
TERMUX_PKG_SRCURL=https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/knotifications-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=36b7881d50400f37b4f3aeaa4c0a6a943e5783d35441e2b0cacdc6dad06af2a1
TERMUX_PKG_DEPENDS="kf6-kconfig (>= ${TERMUX_PKG_VERSION}), libc++, libcanberra, qt6-qtbase, qt6-qtdeclarative"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules (>= ${TERMUX_PKG_VERSION}), qt6-qttools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
