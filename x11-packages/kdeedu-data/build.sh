TERMUX_PKG_HOMEPAGE="https://invent.kde.org/education/kdeedu-data"
TERMUX_PKG_DESCRIPTION="Common data for KDE Edu applications"
TERMUX_PKG_LICENSE="GPL-2.0-or-later, LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.08.3"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kdeedu-data-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=c93742be1812f0afd9c26d034d910ebf26e6382dca54cf55dacbb19fe7385075
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="hicolor-icon-theme"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qtbase"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
