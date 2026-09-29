TERMUX_PKG_HOMEPAGE="https://invent.kde.org/graphics/kcolorchooser"
TERMUX_PKG_DESCRIPTION="Color Chooser"
TERMUX_PKG_LICENSE="GPL-2.0-or-later, LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.08.1"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kcolorchooser-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=7fa2b2d5e552d8205921f25df1a9359d64ceb9f7844d7cf351bf45ca36850a46
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kcoreaddons, kf6-ki18n, kf6-kxmlgui, libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
