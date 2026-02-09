TERMUX_PKG_HOMEPAGE="https://invent.kde.org/frameworks/kplotting"
TERMUX_PKG_DESCRIPTION="Lightweight plotting framework"
TERMUX_PKG_LICENSE="LGPL-2.0-only, LGPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.22.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/kplotting-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="bf2e2c563160d53f7a255e3ea40de6aecb34e19f5e291a284a2d51ff6be0f118"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
