TERMUX_PKG_HOMEPAGE="https://invent.kde.org/frameworks/kholidays"
TERMUX_PKG_DESCRIPTION="KDE library for regional holiday information"
TERMUX_PKG_LICENSE="LGPL-2.0-only, LGPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.23.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/kholidays-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=54c99aca6505c47eed1397ea259312a5b003ca5a622bfb4ecfe01ca6d7644e71
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qtdeclarative, qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
