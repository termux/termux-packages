TERMUX_PKG_HOMEPAGE="https://invent.kde.org/libraries/kqtquickcharts"
TERMUX_PKG_DESCRIPTION="A QtQuick plugin to render beautiful and interactive charts"
TERMUX_PKG_LICENSE="GPL-2.0-or-later, LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.08.1"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kqtquickcharts-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=c768f41e62d71d7ffe8400cfd48986be3a6ebdf6aec64364655abd122210a39a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, qt6-qtbase, qt6-qtdeclarative"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
