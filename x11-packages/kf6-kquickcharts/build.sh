TERMUX_PKG_HOMEPAGE="https://invent.kde.org/frameworks/kquickcharts"
TERMUX_PKG_DESCRIPTION="A QtQuick plugin providing high-performance charts"
TERMUX_PKG_LICENSE="LGPL-2.0-only, LGPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.24.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/kquickcharts-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=3b4a14a8197e2c225dc4717971cc626c9f9b0606c612bcb740f80ef9b6bd1aab
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kirigami, libc++, qt6-qtbase, qt6-qtdeclarative"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-shadertools, qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
