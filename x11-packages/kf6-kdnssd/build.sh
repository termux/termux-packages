TERMUX_PKG_HOMEPAGE="https://invent.kde.org/frameworks/kdnssd"
TERMUX_PKG_DESCRIPTION="Abstraction to system DNSSD features"
TERMUX_PKG_LICENSE="LGPL-2.0-only, LGPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.29.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/kdnssd-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=c48b0c7a06bbcc27e181d9d6f7aeafc2c8bcd4d828497a1e4ddeb252f6fd9674
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
