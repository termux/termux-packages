TERMUX_PKG_HOMEPAGE="https://invent.kde.org/libraries/kqtquickcharts"
TERMUX_PKG_DESCRIPTION="A QtQuick plugin to render beautiful and interactive charts"
TERMUX_PKG_LICENSE="GPL-2.0-or-later, LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.08.2"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kqtquickcharts-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=90deb25fd1c1df5cc36f6aa8ebc393174212580c3fd4d1c2cc47d6197c308151
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, qt6-qtbase, qt6-qtdeclarative"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
