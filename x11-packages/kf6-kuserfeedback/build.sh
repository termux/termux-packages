TERMUX_PKG_HOMEPAGE="https://invent.kde.org/frameworks/kuserfeedback"
TERMUX_PKG_DESCRIPTION="Framework for collecting user feedback for applications via telemetry and surveys"
TERMUX_PKG_LICENSE="LGPL-2.0-only, LGPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.25.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/kuserfeedback-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=4ce9fd672bed20ce646cd175522d207e0fe753fe42c5cf773c087927c0f30fe3
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="clang, extra-cmake-modules, qt6-qtcharts, qt6-qtdeclarative, qt6-qtsvg, qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
