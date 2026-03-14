TERMUX_PKG_HOMEPAGE="https://invent.kde.org/frameworks/kplotting"
TERMUX_PKG_DESCRIPTION="Lightweight plotting framework"
TERMUX_PKG_LICENSE="LGPL-2.0-only, LGPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.24.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/kplotting-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=398cea5da5fb5b505eb34582ec5c318abec75b8c40af98b50f7cf9b6d8a0fecf
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
