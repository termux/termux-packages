TERMUX_PKG_HOMEPAGE="https://invent.kde.org/frameworks/kuserfeedback"
TERMUX_PKG_DESCRIPTION="Framework for collecting user feedback for applications via telemetry and surveys"
TERMUX_PKG_LICENSE="LGPL-2.0-only, LGPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.22.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/kuserfeedback-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=10e2db5703649bfd377121ea2daf629dae8cc082d0457488a04238d55d9e8b87
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="clang, extra-cmake-modules, qt6-qtcharts, qt6-qtdeclarative, qt6-qtsvg, qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
