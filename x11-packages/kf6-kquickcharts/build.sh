TERMUX_PKG_HOMEPAGE="https://invent.kde.org/frameworks/kquickcharts"
TERMUX_PKG_DESCRIPTION="A QtQuick plugin providing high-performance charts"
TERMUX_PKG_LICENSE="LGPL-2.0-only, LGPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.23.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/kquickcharts-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=f7448293f056594f1ebe323a7a3ad0e86103ae526097e158dab63fb932fdae3e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kirigami, libc++, qt6-qtbase, qt6-qtdeclarative"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-shadertools, qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
